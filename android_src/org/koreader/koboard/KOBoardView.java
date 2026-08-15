package org.koreader.koboard;

import android.content.Context;
import android.text.InputType;
import android.text.TextUtils;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.view.inputmethod.InputMethodManager;
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
            InputMethodManager imm = (InputMethodManager)
                getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
            if (imm != null) {
                imm.updateSelection(this, start, end, -1, -1);
            }
        }
    }

    @Override
    public boolean onCheckIsTextEditor() {
        return active;
    }

    @Override
    public InputConnection onCreateInputConnection(EditorInfo outAttrs) {
        outAttrs.inputType = InputType.TYPE_CLASS_TEXT
            | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES;
        outAttrs.imeOptions = EditorInfo.IME_ACTION_NONE
            | EditorInfo.IME_FLAG_NO_EXTRACT_UI
            | EditorInfo.IME_FLAG_NO_FULLSCREEN;
        inputConnection = new KOBoardIC(this, extFilesDir);
        inputConnection.setEditorState(editorText, selectionStart, selectionEnd);
        outAttrs.initialSelStart = selectionStart;
        outAttrs.initialSelEnd = selectionEnd;
        outAttrs.initialCapsMode = TextUtils.getCapsMode(
            editorText,
            Math.max(0, Math.min(selectionStart, editorText.length())),
            TextUtils.CAP_MODE_SENTENCES
        );
        return inputConnection;
    }
}
