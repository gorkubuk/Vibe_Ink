package com.example.myapp

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Color
import android.widget.RemoteViews

class HomeWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val quote = prefs.getString("quote", "Her yeni gun, yeni bir baslangiçtir.") ?: ""
        val colorStr = prefs.getString("color", "#ff10b981") ?: "#ff10b981"
        val color = try { Color.parseColor(colorStr) } catch (e: Exception) { Color.parseColor("#ff10b981") }

        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.home_widget)
            views.setTextViewText(R.id.widget_quote, "“$quote”")
            views.setTextColor(R.id.widget_quote, color)
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}