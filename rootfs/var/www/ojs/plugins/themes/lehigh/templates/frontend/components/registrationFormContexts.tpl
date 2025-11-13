{**
 * templates/frontend/components/registrationFormContexts.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display role selection for all of the journals/presses on this site - Bootstrap 5 styled
 *
 * @uses $contexts array List of journals/presses on this site that have enabled registration
 * @uses $readerUserGroups array Associative array of user groups with reader
 *  permissions in each context.
 * @uses $authorUserGroups array Associative array of user groups with author
 *  permissions in each context.
 * @uses $reviewerUserGroups array Associative array of user groups with reviewer
 *  permissions in each context.
 * @uses $userGroupIds array List group IDs this user is assigned
 *}

{* Only display the context role selection when registration is taking place
   outside of the context of any one journal/press. *}
{if !$currentContext}

	{* Allow users to register for any journal/press on this site *}
	<fieldset name="contexts" class="mb-4">
		<legend class="h5 mb-3">
			{translate key="user.register.contextsPrompt"}
		</legend>
		<div id="contextOptinGroup" class="context_optin">
			<div class="accordion" id="contextAccordion">
				{foreach from=$contexts item=context}
					{assign var=contextId value=$context->getId()}
					{assign var=isSelected value=false}
					<div class="accordion-item">
						<h2 class="accordion-header" id="heading{$contextId}">
							<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse{$contextId}" aria-expanded="false" aria-controls="collapse{$contextId}">
								{$context->getLocalizedName()}
							</button>
						</h2>
						<div id="collapse{$contextId}" class="accordion-collapse collapse" aria-labelledby="heading{$contextId}" data-bs-parent="#contextAccordion">
							<div class="accordion-body">
								<fieldset class="roles mb-3">
									<legend class="h6 mb-2">
										{translate key="user.register.otherContextRoles"}
									</legend>
									{foreach from=$readerUserGroups[$contextId] item=userGroup}
										{if $userGroup->permitSelfRegistration}
											{assign var="userGroupId" value=$userGroup->id}
											<div class="form-check">
												<input
													type="checkbox"
													class="form-check-input"
													name="readerGroup[{$userGroupId}]"
													id="readerGroup{$userGroupId}"
													{if in_array($userGroupId, $userGroupIds)}checked="checked"{/if}
												>
												<label class="form-check-label" for="readerGroup{$userGroupId}">
													{$userGroup->getLocalizedData('name')}
												</label>
											</div>
											{if in_array($userGroupId, $userGroupIds)}
												{assign var=isSelected value=true}
											{/if}
										{/if}
									{/foreach}
									{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
										{if $userGroup->permitSelfRegistration}
											{assign var="userGroupId" value=$userGroup->id}
											<div class="form-check">
												<input
													type="checkbox"
													class="form-check-input"
													name="reviewerGroup[{$userGroupId}]"
													id="reviewerGroup{$userGroupId}"
													{if in_array($userGroupId, $userGroupIds)}checked="checked"{/if}
												>
												<label class="form-check-label" for="reviewerGroup{$userGroupId}">
													{$userGroup->getLocalizedData('name')}
												</label>
											</div>
											{if in_array($userGroupId, $userGroupIds)}
												{assign var=isSelected value=true}
											{/if}
										{/if}
									{/foreach}
								</fieldset>
								{* Require the user to agree to the terms of the context's privacy policy *}
								{if !$enableSiteWidePrivacyStatement && $context->getData('privacyStatement')}
									<div class="context_privacy {if $isSelected}context_privacy_visible{/if}">
										<div class="form-check">
											<input
												type="checkbox"
												class="form-check-input"
												name="privacyConsent[{$contextId}]"
												id="privacyConsent[{$contextId}]"
												value="1"
												{if $privacyConsent[$contextId]}checked="checked"{/if}
											>
											<label class="form-check-label" for="privacyConsent[{$contextId}]">
												{capture assign="privacyUrl"}{url router=PKP\core\PKPApplication::ROUTE_PAGE context=$context->getPath() page="about" op="privacy"}{/capture}
												{translate key="user.register.form.privacyConsentThisContext" privacyUrl=$privacyUrl}
											</label>
										</div>
									</div>
								{/if}
							</div>
						</div>
					</div>
				{/foreach}
			</div>
		</div>
	</fieldset>
{/if}
