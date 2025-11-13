<?php

namespace APP\plugins\themes\lehigh;

use PKP\plugins\ThemePlugin;

class LehighThemePlugin extends ThemePlugin {

	/**
	 * Initialize the theme
	 *
	 * @return null
	 */
	public function init() {
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
