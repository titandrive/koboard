package org.koreader.koboard;

import android.content.Context;
import android.text.InputType;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import java.io.File;

public class KOBoardView extends View {
    private File extFilesDir;
    private boolean active;
    private String editorText = "";
    private int selectionStart;
    private int selectionEnd;
    private KOBoardIC inputConnection;

    public KOBoardView(Context context, File extFilesDir) {
        super(context);
        this.extFilesDir = extFilesDir;
        setFocusable(true);
        setFocusableInTouchMode(true);
    }

    public void setExtFilesDir(File extFilesDir) {
        this.extFilesDir = extFilesDir;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public void setEditorState(String text, int start, int end) {
        editorText = text == null ? "" : text;
        selectionStart = start;
        selectionEnd = end;
        if (inputConnection != null) {
            inputConnection.setEditorState(editorText, start, end);
        }
    }

    @Override
    public boolean onCheckIsTextEditor() {
        return active;
    }

    @Override
    public InputConnection onCreateInputConnection(EditorInfo outAttrs) {
        outAttrs.inputType = InputType.TYPE_CLASS_TEXT;
        outAttrs.imeOptions = EditorInfo.IME_ACTION_NONE
            | EditorInfo.IME_FLAG_NO_EXTRACT_UI
            | EditorInfo.IME_FLAG_NO_FULLSCREEN;
        inputConnection = new KOBoardIC(this, extFilesDir);
        inputConnection.setEditorState(editorText, selectionStart, selectionEnd);
        outAttrs.initialSelStart = selectionStart;
        outAttrs.initialSelEnd = selectionEnd;
        return inputConnection;
    }
}
