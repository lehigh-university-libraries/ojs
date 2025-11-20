/**
 * Lehigh Theme Custom JavaScript
 *
 * This file contains custom JavaScript for the Lehigh theme.
 * To enable this file, uncomment the addScript line in LehighThemePlugin.php
 */

(function($) {
    'use strict';

    $(document).ready(function() {
        console.log('Lehigh theme JavaScript loaded');

        // Example: Add smooth scrolling to all links
        $('a[href^="#"]').on('click', function(event) {
            var target = $(this.getAttribute('href'));
            if(target.length) {
                event.preventDefault();
                $('html, body').stop().animate({
                    scrollTop: target.offset().top - 100
                }, 1000);
            }
        });

        // Example: Initialize all Bootstrap tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Example: Add fade-in animation to cards
        $('.card').each(function(index) {
            $(this).css({
                'opacity': '0',
                'transform': 'translateY(20px)'
            }).delay(index * 100).animate({
                'opacity': '1'
            }, 600, function() {
                $(this).css('transform', 'translateY(0)');
            });
        });

        // Your custom JavaScript code goes here...
    });

})(jQuery);
