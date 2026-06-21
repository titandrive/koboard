package org.koreader.koboard;

import android.app.Activity;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.FrameLayout;
import java.io.File;

public class KOBoardShow implements Runnable {
    private static KOBoardView view;

    private final InputMethodManager imm;
    private final Activity activity;
    private final File extFilesDir;

    public KOBoardShow(InputMethodManager imm, Activity activity, File extFilesDir) {
        this.imm = imm;
        this.activity = activity;
        this.extFilesDir = extFilesDir;
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
        view.setActive(true);
        view.setFocusable(true);
        view.setFocusableInTouchMode(true);
        view.requestFocus();
        imm.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT);
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
