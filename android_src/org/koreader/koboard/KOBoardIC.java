package org.koreader.koboard;

import android.text.Editable;
import android.text.Selection;
import android.util.Base64;
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
    private boolean synchronizing;

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

    public void setEditorState(String text, int selectionStart, int selectionEnd) {
        Editable editable = getEditable();
        if (editable == null) return;
        synchronizing = true;
        editable.replace(0, editable.length(), text == null ? "" : text);
        int start = Math.max(0, Math.min(selectionStart, editable.length()));
        int end = Math.max(0, Math.min(selectionEnd, editable.length()));
        Selection.setSelection(editable, start, end);
        synchronizing = false;
    }

    private void emitState() {
        if (synchronizing) return;
        Editable editable = getEditable();
        if (editable == null) return;
        int start = Selection.getSelectionStart(editable);
        int end = Selection.getSelectionEnd(editable);
        if (start < 0) start = editable.length();
        if (end < 0) end = start;
        String encoded = Base64.encodeToString(
            editable.toString().getBytes(java.nio.charset.StandardCharsets.UTF_8),
            Base64.NO_WRAP
        );
        append("ST:" + start + ":" + end + ":" + encoded);
    }

    @Override
    public boolean commitText(CharSequence text, int newCursorPosition) {
        synchronizing = true;
        boolean handled = super.commitText(text, newCursorPosition);
        synchronizing = false;
        emitState();
        return handled;
    }

    @Override
    public boolean setComposingText(CharSequence text, int newCursorPosition) {
        synchronizing = true;
        boolean handled = super.setComposingText(text, newCursorPosition);
        synchronizing = false;
        emitState();
        return handled;
    }

    @Override
    public boolean finishComposingText() {
        boolean handled = super.finishComposingText();
        emitState();
        return handled;
    }

    @Override
    public CharSequence getTextBeforeCursor(int n, int flags) {
        return super.getTextBeforeCursor(n, flags);
    }

    @Override
    public CharSequence getTextAfterCursor(int n, int flags) {
        return super.getTextAfterCursor(n, flags);
    }

    @Override
    public CharSequence getSelectedText(int flags) {
        return super.getSelectedText(flags);
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

        return result;
    }

    @Override
    public boolean deleteSurroundingText(int beforeLength, int afterLength) {
        synchronizing = true;
        boolean handled = super.deleteSurroundingText(beforeLength, afterLength);
        synchronizing = false;
        emitState();
        return handled;
    }

    @Override
    public boolean deleteSurroundingTextInCodePoints(int beforeLength, int afterLength) {
        synchronizing = true;
        boolean handled = super.deleteSurroundingTextInCodePoints(beforeLength, afterLength);
        synchronizing = false;
        emitState();
        return handled;
    }

    @Override
    public boolean setSelection(int start, int end) {
        boolean handled = super.setSelection(start, end);
        emitState();
        return handled;
    }

    @Override
    public boolean sendKeyEvent(KeyEvent event) {
        if (event != null
                && event.getKeyCode() == KeyEvent.KEYCODE_DEL
                && event.getAction() == KeyEvent.ACTION_DOWN) {
            synchronizing = true;
            boolean handled = super.deleteSurroundingText(1, 0);
            synchronizing = false;
            emitState();
            return handled;
        }
        return super.sendKeyEvent(event);
    }
}
