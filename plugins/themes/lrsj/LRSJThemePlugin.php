<?php

/**
 * @file plugins/themes/lrsj/LRSJThemePlugin.php
 *
 * @class LRSJThemePlugin
 * @brief LRSJ custom theme, extends DefaultThemePlugin with overrides
 */

namespace APP\plugins\themes\lrsj;

use APP\plugins\themes\default\DefaultThemePlugin;
use PKP\plugins\Hook;
use PKP\config\Config;

class LRSJThemePlugin extends DefaultThemePlugin
{
    /**
     * Display name of this plugin
     */
    public function getDisplayName()
    {
        return __('plugins.themes.lrsj.name');
    }

    /**
     * Description of this plugin
     */
    public function getDescription()
    {
        return __('plugins.themes.lrsj.description');
    }

    /**
     * Initialize custom styles, scripts, and hooks
     */
    public function init()
    {
        // Load all of Default theme first
        parent::init();

        // === Custom styles ===
        $this->addStyle('lrsj-theme', 'styles/index.less', ['contexts' => 'frontend']);
        $this->addStyle('lrsj-killRails', 'styles/kill-rails.less', ['contexts' => 'frontend']);

        // === External libs ===
        // FontAwesome (if needed)
        $this->addStyle(
            'fontAwesome',
            'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css',
            ['baseUrl' => '']
        );

        // Swiper (carousel)
        $min = Config::getVar('general', 'enable_minified') ? '.min' : '';
        $this->addScript('swiper', 'js/lib/swiper/swiper-bundle' . $min . '.js');
        $this->addStyle('swiper', 'js/lib/swiper/swiper-bundle' . $min . '.css');
        $this->addScript('swiper-i18n', $this->getSwiperI18n(), ['inline' => true]);

        // === Custom masthead.json hook ===
        $mastheadFile = $this->getPluginPath() . '/masthead.json';
        if (file_exists($mastheadFile)) {
            $mastheadData = json_decode(file_get_contents($mastheadFile), true);

            Hook::register('TemplateManager::display', function ($hookName, $args) use ($mastheadData) {
                $templateMgr = $args[0];
                $templateMgr->assign('customMasthead', $mastheadData);
                return false;
            });
        }

    }

    /**
     * Custom Swiper i18n strings
     */
    public function getSwiperI18n(): string
    {
        return 'var pkpLRSJThemeI18N = ' . json_encode([
            'nextSlide' => __('plugins.themes.lrsj.nextSlide'),
            'prevSlide' => __('plugins.themes.lrsj.prevSlide'),
        ]);
    }
}
