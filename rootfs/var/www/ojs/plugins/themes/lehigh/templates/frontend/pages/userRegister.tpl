{**
 * templates/frontend/pages/userRegister.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * User registration form - Bootstrap 5 styled for Lehigh theme
 *
 * @uses $primaryLocale string The primary locale for this journal/press
 *}
{include file="frontend/components/header.tpl" pageTitle="user.register"}

{assign var="siteContextId" value=PKP\core\PKPApplication::SITE_CONTEXT_ID|intval}

<div class="page page_register">
	<div class="container py-5">
		<div class="row justify-content-center">
			<div class="col-lg-8">
				<div class="card shadow-sm">
					<div class="card-body p-4">
						<h1 class="card-title h3 mb-4 text-center">
							{translate key="user.register"}
						</h1>

						<form class="cmp_form register" id="register" method="post" action="{url op="register"}" role="form">
							{if $orcidEnabled}
								{include file="form/orcidProfile.tpl"}
							{/if}

							{csrf}

							{if $source}
								<input type="hidden" name="source" value="{$source|escape}" />
							{/if}

							{include file="common/formErrors.tpl"}

							{include file="frontend/components/registrationForm.tpl"}

							{* When a user is registering with a specific journal *}
							{if $currentContext}

								{if $currentContext->getData('privacyStatement') || true}
									<fieldset class="consent mb-4">
										{if $currentContext->getData('privacyStatement')}
											{* Require the user to agree to the terms of the privacy policy *}
											<legend class="h5 mb-3">{translate key="user.register.form.privacyConsentLabel"}</legend>
											<div class="mb-3">
												<div class="form-check">
													<input
														type="checkbox"
														class="form-check-input"
														name="privacyConsent"
														id="privacyConsent"
														value="1"
														{if $privacyConsent}checked="checked"{/if}
													>
													<label class="form-check-label" for="privacyConsent">
														{capture assign="privacyUrl"}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="privacy"}{/capture}
														{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}
													</label>
												</div>
											</div>
										{/if}

										{* Ask the user to opt into public email notifications *}
										<div class="mb-3">
											<div class="form-check">
												<input
													type="checkbox"
													class="form-check-input"
													name="emailConsent"
													id="emailConsent"
													value="1"
													{if $emailConsent}checked="checked"{/if}
												>
												<label class="form-check-label" for="emailConsent">
													{translate key="user.register.form.emailConsent"}
												</label>
											</div>
										</div>
									</fieldset>
								{/if}

								{* Allow the user to sign up as a reviewer *}
								{assign var=contextId value=$currentContext->getId()}
								{assign var=userCanRegisterReviewer value=0}
								{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
									{if $userGroup->permitSelfRegistration}
										{assign var=userCanRegisterReviewer value=$userCanRegisterReviewer+1}
									{/if}
								{/foreach}
								{if $userCanRegisterReviewer}
									<fieldset class="reviewer mb-4">
										{if $userCanRegisterReviewer > 1}
											<legend class="h5 mb-3">
												{translate key="user.reviewerPrompt"}
											</legend>
											{capture assign="checkboxLocaleKey"}user.reviewerPrompt.userGroup{/capture}
										{else}
											{capture assign="checkboxLocaleKey"}user.reviewerPrompt.optin{/capture}
										{/if}

										<div id="reviewerOptinGroup" class="mb-3">
											{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
												{if $userGroup->permitSelfRegistration}
													<div class="form-check">
														{assign var="userGroupId" value=$userGroup->id}
														<input
															type="checkbox"
															class="form-check-input"
															name="reviewerGroup[{$userGroupId}]"
															id="reviewerGroup{$userGroupId}"
															value="1"
															{if in_array($userGroupId, $userGroupIds)}checked="checked"{/if}
														>
														<label class="form-check-label" for="reviewerGroup{$userGroupId}">
															{translate key=$checkboxLocaleKey userGroup=$userGroup->getLocalizedData('name')}
														</label>
													</div>
												{/if}
											{/foreach}
										</div>

										<div id="reviewerInterests" class="mb-3">
											<label for="interests" class="form-label">
												{translate key="user.interests"}
											</label>
											<input
												type="text"
												class="form-control"
												name="interests"
												id="interests"
												value="{$interests|default:""|escape}"
											>
										</div>
									</fieldset>
								{/if}
							{/if}

							{include file="frontend/components/registrationFormContexts.tpl"}

							{* When a user is registering for no specific journal, allow them to
							   enter their reviewer interests *}
							{if !$currentContext}
								<div class="mb-3">
									<label for="interests" class="form-label">
										{translate key="user.register.noContextReviewerInterests"}
									</label>
									<input
										type="text"
										class="form-control"
										name="interests"
										id="interests"
										value="{$interests|default:""|escape}"
									>
								</div>

								{* Require the user to agree to the terms of the privacy policy *}
								{if $siteWidePrivacyStatement}
									<div class="mb-3">
										<div class="form-check">
											<input
												type="checkbox"
												class="form-check-input"
												name="privacyConsent[{$siteContextId}]"
												id="privacyConsent[{$siteContextId}]"
												value="1"
												{if $privacyConsent[$siteContextId]}checked="checked"{/if}
											>
											<label class="form-check-label" for="privacyConsent[{$siteContextId}]">
												{capture assign="privacyUrl"}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="privacy"}{/capture}
												{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}
											</label>
										</div>
									</div>
								{/if}

								{* Ask the user to opt into public email notifications *}
								<div class="mb-3">
									<div class="form-check">
										<input
											type="checkbox"
											class="form-check-input"
											name="emailConsent"
											id="emailConsentNoContext"
											value="1"
											{if $emailConsent}checked="checked"{/if}
										>
										<label class="form-check-label" for="emailConsentNoContext">
											{translate key="user.register.form.emailConsent"}
										</label>
									</div>
								</div>
							{/if}

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

							<div class="d-grid gap-2 mb-3">
								<button class="btn btn-primary btn-lg" type="submit">
									{translate key="user.register"}
								</button>
							</div>

							<div class="text-center">
								{capture assign="rolesProfileUrl"}{url page="user" op="profile" path="roles"}{/capture}
								<p class="mb-0">
									{translate key="user.login.loginLabel"}
									<a href="{url page="login" source=$rolesProfileUrl}" class="fw-semibold">
										{translate key="user.login"}
									</a>
								</p>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
