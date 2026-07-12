package org.koreader.koboard;

import android.text.Editable;
import android.text.Selection;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.BaseInputConnection;
import android.view.inputmethod.ExtractedText;
import android.view.inputmethod.ExtractedTextRequest;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class KOBoardIC extends BaseInputConnection {
    private final File actionFile;
    private final File debugFile;

    public KOBoardIC(View targetView, File extFilesDir) {
        super(targetView, true);
        this.actionFile = new File(extFilesDir, "koboard_input");
        this.debugFile = new File(extFilesDir, "koboard_debug.txt");
    }

    private void append(String action) {
        try {
            FileWriter writer = new FileWriter(actionFile, true);
            writer.write(action);
            writer.write("\n");
            writer.close();
        } catch (IOException ignored) {
        }
    }

    private void log(String message) {
        try {
            FileWriter writer = new FileWriter(debugFile, true);
            writer.write(message);
            writer.write("\n");
            writer.close();
        } catch (IOException ignored) {
        }
    }

    private void deleteText(int count) {
        for (int i = 0; i < count; i++) {
            append("BS");
        }
    }

    private String editableText() {
        Editable editable = getEditable();
        return editable == null ? "" : editable.toString();
    }

    private boolean forwardDifference(String before, String after) {
        int prefixLength = 0;
        int prefixLimit = Math.min(before.length(), after.length());

        while (prefixLength < prefixLimit
                && before.charAt(prefixLength) == after.charAt(prefixLength)) {
            prefixLength++;
        }

        int suffixLength = 0;
        int suffixLimit = Math.min(
            before.length() - prefixLength,
            after.length() - prefixLength
        );

        while (suffixLength < suffixLimit
                && before.charAt(before.length() - suffixLength - 1)
                    == after.charAt(after.length() - suffixLength - 1)) {
            suffixLength++;
        }

        int removedLength =
            before.length() - prefixLength - suffixLength;

        String inserted =
            after.substring(prefixLength, after.length() - suffixLength);

        if (removedLength == 0 && inserted.length() == 0) {
            return false;
        }

        // KOReader can only edit immediately before the cursor.
        // If the changed region has a preserved suffix, temporarily
        // remove that suffix, apply the replacement, then restore it.
        deleteText(removedLength + suffixLength);

        if (inserted.length() > 0) {
            append("CH:" + inserted);
        }

        if (suffixLength > 0) {
            append("CH:" + after.substring(after.length() - suffixLength));
        }

        return true;
    }

    @Override
    public boolean commitText(CharSequence text, int newCursorPosition) {
        log("commitText text=[" + text + "] cursor=" + newCursorPosition
            + " editable=[" + editableText() + "]");
        String before = editableText();
        boolean handled = super.commitText(text, newCursorPosition);
        forwardDifference(before, editableText());
        return handled;
    }

    @Override
    public boolean setComposingText(CharSequence text, int newCursorPosition) {
        log("setComposingText text=[" + text + "] cursor=" + newCursorPosition
            + " editable=[" + editableText() + "]");
        String before = editableText();
        boolean handled = super.setComposingText(text, newCursorPosition);
        forwardDifference(before, editableText());
        return handled;
    }

    @Override
    public boolean finishComposingText() {
        log("finishComposingText editable=[" + editableText() + "]");
        return super.finishComposingText();
    }

    @Override
    public CharSequence getTextBeforeCursor(int n, int flags) {
        CharSequence result = super.getTextBeforeCursor(n, flags);
        log("getTextBeforeCursor n=" + n + " flags=" + flags
            + " result=[" + result + "]");
        return result;
    }

    @Override
    public CharSequence getTextAfterCursor(int n, int flags) {
        CharSequence result = super.getTextAfterCursor(n, flags);
        log("getTextAfterCursor n=" + n + " flags=" + flags
            + " result=[" + result + "]");
        return result;
    }

    @Override
    public CharSequence getSelectedText(int flags) {
        CharSequence result = super.getSelectedText(flags);
        log("getSelectedText flags=" + flags + " result=[" + result + "]");
        return result;
    }

    @Override
    public ExtractedText getExtractedText(ExtractedTextRequest request, int flags) {
        Editable editable = getEditable();

        ExtractedText result = new ExtractedText();
        result.text = editable == null ? "" : editable.toString();
        result.startOffset = 0;
        result.partialStartOffset = -1;
        result.partialEndOffset = -1;

        if (editable != null) {
            int selectionStart = Selection.getSelectionStart(editable);
            int selectionEnd = Selection.getSelectionEnd(editable);

            result.selectionStart = selectionStart >= 0
                ? selectionStart
                : editable.length();

            result.selectionEnd = selectionEnd >= 0
                ? selectionEnd
                : editable.length();
        } else {
            result.selectionStart = 0;
            result.selectionEnd = 0;
        }

        log("getExtractedText flags=" + flags
            + " text=[" + result.text + "]"
            + " selectionStart=" + result.selectionStart
            + " selectionEnd=" + result.selectionEnd);

        return result;
    }

    @Override
    public boolean deleteSurroundingText(int beforeLength, int afterLength) {
        String before = editableText();
        boolean handled = super.deleteSurroundingText(beforeLength, afterLength);
        if (!forwardDifference(before, editableText()) && beforeLength > 0) {
            // The Java buffer does not know about text that predates this input
            // connection, but KOReader may still have text to erase.
            deleteText(beforeLength);
        }
        return handled;
    }

    @Override
    public boolean deleteSurroundingTextInCodePoints(int beforeLength, int afterLength) {
        String before = editableText();
        boolean handled = super.deleteSurroundingTextInCodePoints(beforeLength, afterLength);
        if (!forwardDifference(before, editableText()) && beforeLength > 0) {
            deleteText(beforeLength);
        }
        return handled;
    }

    @Override
    public boolean sendKeyEvent(KeyEvent event) {
        if (event != null
                && event.getKeyCode() == KeyEvent.KEYCODE_DEL
                && event.getAction() == KeyEvent.ACTION_DOWN) {
            String before = editableText();
            boolean handled = super.deleteSurroundingText(1, 0);
            if (!forwardDifference(before, editableText())) {
                deleteText(1);
            }
            return handled;
        }
        return super.sendKeyEvent(event);
    }
}
