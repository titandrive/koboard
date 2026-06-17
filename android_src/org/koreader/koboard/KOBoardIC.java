package org.koreader.koboard;

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

    private boolean backspace() {
        append("BS");
        return true;
    }

    @Override
    public boolean commitText(CharSequence text, int newCursorPosition) {
        if (text != null && text.length() > 0) {
            append("CH:" + text.toString());
        }
        return true;
    }

    @Override
    public boolean setComposingText(CharSequence text, int newCursorPosition) {
        if (text != null && text.length() > 0) {
            append("CH:" + text.toString());
        }
        return true;
    }

    @Override
    public boolean finishComposingText() {
        return true;
    }

    @Override
    public boolean deleteSurroundingText(int beforeLength, int afterLength) {
        return backspace();
    }

    @Override
    public boolean deleteSurroundingTextInCodePoints(int beforeLength, int afterLength) {
        return backspace();
    }

    @Override
    public boolean sendKeyEvent(KeyEvent event) {
        if (event != null
                && event.getKeyCode() == KeyEvent.KEYCODE_DEL
                && event.getAction() == KeyEvent.ACTION_DOWN) {
            return backspace();
        }
        return super.sendKeyEvent(event);
    }

    @Override
    public CharSequence getTextBeforeCursor(int length, int flags) {
        return "x";
    }

    @Override
    public CharSequence getSelectedText(int flags) {
        return "";
    }

    @Override
    public CharSequence getTextAfterCursor(int length, int flags) {
        return "";
    }
}
