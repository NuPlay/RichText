//
//  RichTextConstants.swift
//  
//
//  Created by 이웅재(NuPlay) on 2025/08/24.
//  https://github.com/NuPlay/RichText

import Foundation

/// Constants used throughout the RichText framework v3.0.0+
/// 
/// Public constants that maintain backward compatibility
/// while providing modern, performant implementations.
public struct RichTextConstants {
    
    // MARK: - Default Values (v3.0.0 - Optimized for modern displays)
    public static let defaultLineHeight: CGFloat = 170
    public static let defaultImageRadius: CGFloat = 0
    public static let defaultLightColor = "000000"
    public static let defaultDarkColor = "F2F2F2"
    public static let defaultLinkLightColor = "007AFF"
    public static let defaultLinkDarkColor = "0A84FF"
    
    // MARK: - CSS Properties (v3.0.0 - Enhanced precision)
    public static let iframeHeight = 250
    /// Optimized color multiplier for precise RGBA conversion
    public static let colorMultiplier: CGFloat = 255.999999
    
    // MARK: - JavaScript Handler Names (v3.0.0 - Async optimized)
    public static let heightNotificationHandler = "notifyCompletion"
    public static let mediaClickHandler = "mediaClick"
    
    // MARK: - HTML Element IDs (v3.0.0)
    public static let richTextContainerID = "NuPlay_RichText"
    
    // MARK: - Font Names (v3.0.0 - Enhanced system font support)
    public static let systemFontName = "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif"
    
    // MARK: - URL Schemes (v3.0.0)
    public static let mailtoScheme = "mailto"
    public static let telScheme = "tel"
    public static let httpScheme = "http"
    public static let httpsScheme = "https"
    
    // MARK: - CSS Selectors and Properties (v3.0.0 - Performance optimized)
    public static let imageCSS = "img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: %@px; loading: lazy;}"
    public static let textCSS = "h1, h2, h3, h4, h5, h6, p, div, dl, ol, ul, pre, blockquote, figure, figcaption, details, summary, article, section, aside, header, footer, nav, main {text-align:%@; line-height: %@%%; font-family: %@; color: %@; background-color: %@; word-wrap: break-word; }"
    public static let iframeCSS = "iframe{width:100%%; height:%dpx; border: none;}"
    public static let linkCSS = "a:link {color: %@; transition: color 0.2s ease;}"
    public static let linkDecorationCSS = "A {text-decoration: none;} A:hover {text-decoration: underline;}"
    public static let bodyCSS = "body { margin: 0; padding: 0; -webkit-text-size-adjust: 100%; }"
    
    // MARK: - HTML5 Semantic Elements CSS (v3.0.0 - Enhanced accessibility)
    public static let html5ElementsCSS = """
        figure { margin: 1em 0; padding: 0; }
        figcaption { font-size: 0.9em; font-style: italic; margin-top: 0.5em; text-align: center; }
        details { margin: 1em 0; padding: 0; }
        summary { cursor: pointer; font-weight: bold; margin-bottom: 0.5em; }
        summary::-webkit-details-marker { display: none; }
        summary::before { content: '▶ '; display: inline-block; transition: transform 0.2s; }
        details[open] summary::before { transform: rotate(90deg); }
        article, section, aside { margin: 1em 0; }
        header, footer { margin: 1.5em 0; }
        nav ul { list-style: none; padding: 0; }
        nav li { display: inline-block; margin-right: 1em; }
        """
    
    // MARK: - Dynamic Type CSS (v3.0.0 - Improved accessibility)
    public static let dynamicTypeCSS = """
        html { font: -apple-system-body; }
        
        body { font: -apple-system-body; }
        
        h1 { font: -apple-system-largeTitle; }
        h2 { font: -apple-system-title1; }
        h3 { font: -apple-system-title2; }
        h4 { font: -apple-system-title3; }
        
        h5 { font: -apple-system-headline; }
        h6 { font: -apple-system-callout; }
        
        p.subheadline { font: -apple-system-subheadline; }
        p.footnote    { font: -apple-system-footnote; }
        p.caption1    { font: -apple-system-caption1; }
        p.caption2    { font: -apple-system-caption2; }
        """
    
    // MARK: - HTML Templates (v3.0.0 - Modern, accessible markup)
    public static let htmlTemplate = """
        <HTML>
        <head>
            <meta name='viewport' content='width=device-width, shrink-to-fit=YES, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
        </head>
        %@
        <div id="%@">%@</div>
        </BODY>
        <script>
            var richTextHeightHandler = '%@';
            var richTextContainer = document.getElementById('%@');
            var richTextLastReportedHeight = -1;

            function syncHeight() {
              if (!richTextContainer) { return; }
              if (!window.webkit || !window.webkit.messageHandlers) { return; }

              var handler = window.webkit.messageHandlers[richTextHeightHandler];
              if (!handler) { return; }

              var boundingHeight = richTextContainer.getBoundingClientRect().height;
              var height = Math.ceil(Math.max(richTextContainer.scrollHeight, boundingHeight));

              // Skip redundant round trips; the native side re-renders on every update.
              if (height === richTextLastReportedHeight) { return; }
              richTextLastReportedHeight = height;
              handler.postMessage(height);
            }

            function handleMediaClick(element, type) {
              if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.%@) {
                window.webkit.messageHandlers.%@.postMessage({
                  type: type,
                  src: element.src || element.getAttribute('src')
                });
              }
            }

            function attachMediaHandlers() {
              var imgs = document.getElementsByTagName('img');
              for (var i = 0; i < imgs.length; i++) {
                if (imgs[i].dataset.richTextBound) { continue; }
                imgs[i].dataset.richTextBound = '1';
                imgs[i].addEventListener('load', syncHeight);
                imgs[i].addEventListener('error', syncHeight);
                imgs[i].onclick = function () {
                  handleMediaClick(this, 'image');
                };
              }

              var videos = document.getElementsByTagName('video');
              for (var j = 0; j < videos.length; j++) {
                if (videos[j].dataset.richTextBound) { continue; }
                videos[j].dataset.richTextBound = '1';
                videos[j].addEventListener('loadedmetadata', syncHeight);
                videos[j].onclick = function () {
                  handleMediaClick(this, 'video');
                };
              }
            }

            attachMediaHandlers();
            syncHeight();

            // The rendered height keeps changing after the first layout pass: images and
            // web fonts finish loading, <details> elements are toggled open, the device is
            // rotated, Dynamic Type changes. A one-shot measurement on window.onload misses
            // all of those and the content ends up clipped, so observe the container instead.
            if (window.ResizeObserver && richTextContainer) {
              new ResizeObserver(syncHeight).observe(richTextContainer);
            }

            if (window.MutationObserver && richTextContainer) {
              new MutationObserver(function () {
                attachMediaHandlers();
                syncHeight();
              }).observe(richTextContainer, { childList: true, subtree: true });
            }

            // `toggle` does not bubble, so it has to be observed during the capture phase.
            document.addEventListener('toggle', syncHeight, true);
            window.addEventListener('load', syncHeight);
            window.addEventListener('resize', syncHeight);
            window.addEventListener('orientationchange', syncHeight);

            if (document.fonts && document.fonts.ready) {
              document.fonts.ready.then(syncHeight);
            }
        </script>
        </HTML>
        """
    
    public static let cssTemplate = """
        <style type='text/css'>
            %@
            %@
            body {
                margin: 0;
                padding: 0;
            }
        </style>
        <BODY>
        """
    
    public static let mediaCSSTemplate = """
        <style type='text/css'>
        @media (prefers-color-scheme: light) {
            %@
        }
        @media (prefers-color-scheme: dark) {
            %@
        }
        %@
        body {
            margin: 0;
            padding: 0;
        }
        </style>
        <BODY>
        """
}