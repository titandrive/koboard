package org.koreader.koboard;

import android.text.Editable;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.BaseInputConnection;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class KOBoardIC extends BaseInputConnection {
    private final File actionFile;

    public KOBoardIC(View targetView, File extFilesDir) {
        super(targetView, true);
        this.actionFile = new File(extFilesDir, "koboard_input");
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

        int removedLength = before.length() - prefixLength - suffixLength;
        String inserted = after.substring(prefixLength, after.length() - suffixLength);
        deleteText(removedLength);
        if (inserted.length() > 0) {
            append("CH:" + inserted);
        }
        return removedLength > 0 || inserted.length() > 0;
    }

    @Override
    public boolean commitText(CharSequence text, int newCursorPosition) {
        String before = editableText();
        boolean handled = super.commitText(text, newCursorPosition);
        forwardDifference(before, editableText());
        return handled;
    }

    @Override
    public boolean setComposingText(CharSequence text, int newCursorPosition) {
        String before = editableText();
        boolean handled = super.setComposingText(text, newCursorPosition);
        forwardDifference(before, editableText());
        return handled;
    }

    @Override
    public boolean finishComposingText() {
        return super.finishComposingText();
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
