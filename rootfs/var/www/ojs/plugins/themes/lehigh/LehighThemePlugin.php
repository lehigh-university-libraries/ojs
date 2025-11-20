<?php

namespace APP\plugins\themes\lehigh;

use PKP\plugins\ThemePlugin;
use APP\journal\Journal;
use APP\core\Application;

class LehighThemePlugin extends ThemePlugin {

	/**
	 * Initialize the theme
	 *
	 * @return null
	 */
	public function init() {
		// Load Bootstrap 5.3.8 CSS
		$this->addStyle(
			'bootstrap-css',
			'https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css',
			['contexts' => 'frontend', 'baseUrl' => '']
		);

		// Load Lehigh Reset CSS
		$this->addStyle(
			'lehigh-reset',
			'https://www.lehigh.edu/~inltswms/include/ltstemplate/css/lehigh-reset.min.css',
			['contexts' => 'frontend', 'baseUrl' => '']
		);

		// Load Lehigh Styles CSS
		$this->addStyle(
			'lehigh-styles',
			'https://www.lehigh.edu/~inltswms/include/ltstemplate/css/styles.min.css',
			['contexts' => 'frontend', 'baseUrl' => '']
		);

		// Load Bootstrap 5.3.8 JavaScript
		$this->addScript(
			'bootstrap-js',
			'https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js',
			['contexts' => 'frontend', 'baseUrl' => '']
		);
		$this->addScript(
			'jquery-js',
			'https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js',
			['contexts' => 'frontend', 'baseUrl' => '']
		);

		// Load Lehigh Scripts JS
		$this->addScript(
			'lehigh-scripts',
			'https://www.lehigh.edu/~inltswms/include/ltstemplate/js/scripts.js',
			['contexts' => 'frontend', 'baseUrl' => '']
		);

		// Register template hooks to pass constants to templates
		\HookRegistry::register('TemplateManager::display', [$this, 'addTemplateData']);
	}

	/**
	 * Add template data to make constants available in templates
	 */
	public function addTemplateData($hookName, $args) {
		$templateMgr = $args[0];

		// Pass Journal publishing mode constant to templates
		$templateMgr->assign('PUBLISHING_MODE_NONE', Journal::PUBLISHING_MODE_NONE);

		return false;
	}

	/**
	 * Get the display name of this plugin
	 * @return string
	 */
	function getDisplayName() {
		return "Lehigh";
	}

	/**
	 * Get the description of this plugin
	 * @return string
	 */
	function getDescription() {
		return "Lehigh base theme";
	}

}

if (!PKP_STRICT_MODE) {
    class_alias('\APP\plugins\themes\lehigh\LehighThemePlugin', '\LehighThemePlugin');
}
