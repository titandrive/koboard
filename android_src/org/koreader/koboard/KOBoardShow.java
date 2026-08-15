package org.koreader.koboard;

import android.app.Activity;
import android.graphics.Point;
import android.graphics.Rect;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.inputmethod.InputMethodManager;
import android.widget.FrameLayout;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class KOBoardShow implements Runnable {
    private static KOBoardView view;
    private static ViewTreeObserver.OnGlobalLayoutListener layoutListener;

    private final InputMethodManager imm;
    private final Activity activity;
    private final File extFilesDir;
    private final String editorText;
    private final int selectionStart;
    private final int selectionEnd;

    public KOBoardShow(InputMethodManager imm, Activity activity, File extFilesDir,
            String editorText, int selectionStart, int selectionEnd) {
        this.imm = imm;
        this.activity = activity;
        this.extFilesDir = extFilesDir;
        this.editorText = editorText;
        this.selectionStart = selectionStart;
        this.selectionEnd = selectionEnd;
    }

    @Override
    public void run() {
        if (view == null) {
            view = new KOBoardView(activity, extFilesDir);
            FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(1, 1);
            params.leftMargin = 0;
            params.topMargin = 0;
            activity.addContentView(view, params);
        } else {
            view.setExtFilesDir(extFilesDir);
        }

        view.setVisibility(View.VISIBLE);
        view.setEditorState(editorText, selectionStart, selectionEnd);
        view.setActive(true);
        view.setFocusable(true);
        view.setFocusableInTouchMode(true);
        view.requestFocus();
        installKeyboardHeightListener();
        imm.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT);
    }

    private void installKeyboardHeightListener() {
        if (layoutListener != null) {
            return;
        }
        final View root = activity.getWindow().getDecorView();
        layoutListener = new ViewTreeObserver.OnGlobalLayoutListener() {
            private int lastHeight = -1;

            @Override
            public void onGlobalLayout() {
                Rect visible = new Rect();
                root.getWindowVisibleDisplayFrame(visible);
                // visible.bottom is in display coordinates, while root.getHeight()
                // excludes some system-bar regions on fullscreen KOReader. Use the
                // display height so both sides of the subtraction share coordinates.
                Point displaySize = new Point();
                activity.getWindowManager().getDefaultDisplay().getRealSize(displaySize);
                int height = Math.max(0, displaySize.y - visible.bottom);
                if (height == lastHeight) {
                    return;
                }
                lastHeight = height;
                publishKeyboardHeight(height);
            }
        };
        root.getViewTreeObserver().addOnGlobalLayoutListener(layoutListener);
    }

    private void publishKeyboardHeight(int height) {
        File target = new File(extFilesDir, "koboard_height");
        File temporary = new File(extFilesDir, "koboard_height.tmp");
        try {
            FileWriter writer = new FileWriter(temporary, false);
            writer.write(Integer.toString(height));
            writer.close();
            if (!temporary.renameTo(target)) {
                FileWriter fallback = new FileWriter(target, false);
                fallback.write(Integer.toString(height));
                fallback.close();
                temporary.delete();
            }
        } catch (IOException ignored) {
        }
    }

    public static void updateState(final String text, final int start, final int end) {
        if (view != null) {
            view.post(new Runnable() {
                @Override
                public void run() {
                    view.setEditorState(text, start, end);
                }
            });
        }
    }

    public static void hide() {
        if (view != null) {
            view.post(new Runnable() {
                @Override
                public void run() {
                    view.setActive(false);
                    view.clearFocus();
                    view.setVisibility(View.GONE);
                }
            });
        }
    }
}
