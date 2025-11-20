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
