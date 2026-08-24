{**
 * templates/frontend/components/registrationForm.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the basic registration form fields - Bootstrap 5 styled for Lehigh theme
 *
 * @uses $locale string Locale key to use in the affiliate field
 * @uses $givenName string First name input entry if available
 * @uses $familyName string Last name input entry if available
 * @uses $countries array List of country options
 * @uses $country string The selected country if available
 * @uses $email string Email input entry if available
 * @uses $username string Username input entry if available
 *}
<fieldset class="identity mb-4">
	<legend class="h5 mb-3">
		{translate key="user.profile"}
	</legend>
	<div class="row g-3">
		<div class="col-md-6">
			<label for="givenName" class="form-label">
				{translate key="user.givenName"}
				<span class="text-danger">*</span>
			</label>
			<input
				type="text"
				class="form-control"
				name="givenName"
				id="givenName"
				autocomplete="given-name"
				value="{$givenName|default:""|escape}"
				maxlength="255"
				required
				aria-required="true"
			>
		</div>
		<div class="col-md-6">
			<label for="familyName" class="form-label">
				{translate key="user.familyName"}
			</label>
			<input
				type="text"
				class="form-control"
				name="familyName"
				id="familyName"
				autocomplete="family-name"
				value="{$familyName|default:""|escape}"
				maxlength="255"
			>
		</div>
		<div class="col-12">
			<label for="affiliation" class="form-label">
				{translate key="user.affiliation"}
				<span class="text-danger">*</span>
			</label>
			<input
				type="text"
				class="form-control"
				name="affiliation"
				id="affiliation"
				autocomplete="organization"
				value="{$affiliation|default:""|escape}"
				required
				aria-required="true"
			>
		</div>
		<div class="col-md-6">
			<label for="country" class="form-label">
				{translate key="common.country"}
				<span class="text-danger">*</span>
			</label>
			<select
				class="form-select"
				name="country"
				id="country"
				autocomplete="country-name"
				required
				aria-required="true"
			>
				<option value="">Select a country...</option>
				{html_options options=$countries selected=$country}
			</select>
		</div>
	</div>
</fieldset>

<fieldset class="login mb-4">
	<legend class="h5 mb-3">
		{translate key="user.login"}
	</legend>
	<div class="row g-3">
		<div class="col-md-6">
			<label for="email" class="form-label">
				{translate key="user.email"}
				<span class="text-danger">*</span>
			</label>
			<input
				type="email"
				class="form-control"
				name="email"
				id="email"
				value="{$email|default:""|escape}"
				maxlength="90"
				required
				aria-required="true"
				autocomplete="email"
			>
		</div>
		<div class="col-md-6">
			<label for="username" class="form-label">
				{translate key="user.username"}
				<span class="text-danger">*</span>
			</label>
			<input
				type="text"
				class="form-control"
				name="username"
				id="username"
				value="{$username|default:""|escape}"
				maxlength="32"
				required
				aria-required="true"
				autocomplete="username"
			>
		</div>
		<div class="col-md-6">
			<label for="password" class="form-label">
				{translate key="user.password"}
				<span class="text-danger">*</span>
			</label>
			<input
				type="password"
				class="form-control"
				name="password"
				id="password"
				maxlength="32"
				required
				aria-required="true"
				autocomplete="new-password"
			>
		</div>
		<div class="col-md-6">
			<label for="password2" class="form-label">
				{translate key="user.repeatPassword"}
				<span class="text-danger">*</span>
			</label>
			<input
				type="password"
				class="form-control"
				name="password2"
				id="password2"
				maxlength="32"
				required
				aria-required="true"
				autocomplete="new-password"
			>
		</div>
	</div>
</fieldset>
