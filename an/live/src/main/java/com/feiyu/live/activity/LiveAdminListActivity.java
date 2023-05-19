package com.feiyu.live.activity;

import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.view.ViewGroup;

import com.feiyu.common.Constants;
import com.feiyu.common.activity.AbsActivity;
import com.feiyu.live.R;
import com.feiyu.live.views.LiveAdminListViewHolder;

/**
 * Created by cxf on 2019/4/27.
 */

public class LiveAdminListActivity extends AbsActivity {

    public static void forward(Context context, String liveUid) {
        Intent intent = new Intent(context, LiveAdminListActivity.class);
        intent.putExtra(Constants.LIVE_UID, liveUid);
        context.startActivity(intent);
    }

    @Override
    protected int getLayoutId() {
        return R.layout.activity_live_admin_list;
    }

    @Override
    protected void main() {
        String liveUid = getIntent().getStringExtra(Constants.LIVE_UID);
        if (TextUtils.isEmpty(liveUid)) {
            return;
        }
        LiveAdminListViewHolder liveAdminListViewHolder = new LiveAdminListViewHolder(mContext, (ViewGroup) findViewById(R.id.container), liveUid);
        liveAdminListViewHolder.addToParent();
        liveAdminListViewHolder.subscribeActivityLifeCycle();
        liveAdminListViewHolder.loadData();
    }
}
