{**
 * templates/frontend/pages/userLogin.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2000-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * User login form - Bootstrap 5 styled for Lehigh theme
 *
 *}
{include file="frontend/components/header.tpl" pageTitle="user.login"}

<div class="page page_login">
	<div class="container py-5">
		<div class="row justify-content-center">
			<div class="col-md-6 col-lg-5">
				<div class="card shadow-sm">
					<div class="card-body p-4">
						<h1 class="card-title h3 mb-4 text-center">
							{translate key="user.login"}
						</h1>

						{* A login message may be displayed if the user was redirected to the
						   login page from another request. Examples include if login is required
						   before downloading a file. *}
						{if $loginMessage}
							<div class="alert alert-info" role="alert">
								{translate key=$loginMessage}
							</div>
						{/if}

						{if $error}
							<div class="alert alert-danger" role="alert">
								{translate key=$error reason=$reason}
							</div>
						{/if}

						<form class="cmp_form login" id="login" method="post" action="{$loginUrl}" role="form">
							{csrf}

							<input type="hidden" name="source" value="{$source|default:""|escape}" />

							<div class="mb-3">
								<label for="username" class="form-label">
									{translate key="user.usernameOrEmail"}
									<span class="text-danger">*</span>
								</label>
								<input
									type="text"
									class="form-control"
									name="username"
									id="username"
									value="{$username|default:""|escape}"
									required
									aria-required="true"
									autocomplete="username"
								>
							</div>

							<div class="mb-3">
								<label for="password" class="form-label">
									{translate key="user.password"}
									<span class="text-danger">*</span>
								</label>
								<input
									type="password"
									class="form-control"
									name="password"
									id="password"
									value="{$password|default:""|escape}"
									maxlength="32"
									required
									aria-required="true"
									autocomplete="current-password"
								>
								<div class="form-text">
									<a href="{url page="login" op="lostPassword"}">
										{translate key="user.login.forgotPassword"}
									</a>
								</div>
							</div>

							<div class="mb-3 form-check">
								<input
									type="checkbox"
									class="form-check-input"
									name="remember"
									id="remember"
									value="1"
									{if $remember}checked{/if}
								>
								<label class="form-check-label" for="remember">
									{translate key="user.login.rememberUsernameAndPassword"}
								</label>
							</div>

							{* recaptcha spam blocker *}
							{if $recaptchaPublicKey}
								<div class="mb-3">
									<div class="g-recaptcha" data-sitekey="{$recaptchaPublicKey|escape}"></div>
									<label for="g-recaptcha-response" style="display:none;" hidden>Recaptcha response</label>
								</div>
							{/if}

							{* altcha spam blocker *}
							{if $altchaEnabled}
								<div class="mb-3">
									<altcha-widget challengejson='{$altchaChallenge|@json_encode}' floating></altcha-widget>
								</div>
							{/if}

							<div class="d-grid gap-2">
								<button class="btn btn-primary btn-lg" type="submit">
									{translate key="user.login"}
								</button>
							</div>

							{if !$disableUserReg}
								<div class="text-center mt-3">
									{capture assign=registerUrl}{url page="user" op="register" source=$source}{/capture}
									<p class="mb-0">
										<a href="{$registerUrl}" class="fw-semibold">
											{translate key="user.register"}
										</a>
									</p>
								</div>
							{/if}
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
