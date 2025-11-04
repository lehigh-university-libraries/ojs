{** Theme override of the home page **}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal">

	{* keep default hook and widgets *}
	{call_hook name="Templates::Index::journal"}

	{if $highlights->count()}
		{include file="frontend/components/highlights.tpl" highlights=$highlights}
	{/if}

	{if $activeTheme && !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
		<div class="homepage_image">
			<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"{if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{/if}>
		</div>
	{/if}
	

	<section class="lrsj-hero">
		<div class="lrsj-container lrsj-about-grid">

			{* LEFT: About the Journal *}
			<div class="lrsj-about">
			  <h1 class="lrsj-h1">About The Journal</h1>
			  {assign var=aboutHtml value=$currentContext->getLocalizedData('description')}
			  {if $aboutHtml}
				<div class="lrsj-about-text">
				  {$aboutHtml}
				</div>
			  {/if}

			  <a href="{url page='issue' op='current'}" class="lrsj-cta-btn lrsj-inline-btn">
				View Current Issue
			  </a>
			  
			  <a href="{url page='about'}" class="lrsj-cta-btn lrsj-inline-btn">
                 Join as Author/Reviewer
              </a>
			</div>

			{* RIGHT: Publication Process card (edit text to taste) *}
			<aside class="lrsj-process">
				<h2 class="lrsj-h2">Publication Process</h2>
				<ol class="lrsj-steps">
					<li><span class="lrsj-stepnum">1</span><div><strong>Submission</strong><p>Authors submit manuscripts through our online portal.</p></div></li>
					<li><span class="lrsj-stepnum">2</span><div><strong>Initial Review</strong><p>Editorial board checks scope & basic requirements.</p></div></li>
					<li><span class="lrsj-stepnum">3</span><div><strong>Peer Review</strong><p>Reviewed by at least two experts.</p></div></li>
					<li><span class="lrsj-stepnum">4</span><div><strong>Decision</strong><p>Accept, revise, or reject communicated to author.</p></div></li>
				</ol>
			</aside>

		</div>
	</section>
	
	{* ===== Review Process ===== *}
	<section class="lrsj-review">
	  <div class="pkp_container">
		<div class="lrsj-center mb-12">
		  <h2 class="lrsj-h2">Our Peer Review Process</h2>
		  <p class="lrsj-lead">We maintain the highest academic standards through a transparent and rigorous review process</p>
		</div>

		<div class="lrsj-grid-3">
		  <article class="lrsj-card">
			<div class="lrsj-stepnum">1</div>
			<h3>Editorial Screening</h3>
			<p>Each submission is first reviewed by our editorial board to ensure it meets basic standards and fits within the journal's scope.</p>
		  </article>

		  <article class="lrsj-card">
			<div class="lrsj-stepnum">2</div>
			<h3>Expert Review</h3>
			<p>Qualified reviewers with expertise in the relevant field conduct a thorough evaluation of the manuscript's quality and originality.</p>
		  </article>

		  <article class="lrsj-card">
			<div class="lrsj-stepnum">3</div>
			<h3>Decision &amp; Feedback</h3>
			<p>Authors receive detailed feedback and one of three decisions: Accept, Revise, or Reject, typically within 6–8 weeks.</p>
		  </article>
		</div>
	  </div>
	</section>

	{include file="frontend/objects/announcements_list.tpl" numAnnouncements=$numAnnouncementsHomepage}

	{* Latest issue (unchanged) *}
	{if $issue}
		<section class="current_issue">
			<a id="homepageIssue"></a>
			<h2>{translate key="journal.currentIssue"}</h2>
			<div class="current_issue_title">{$issue->getIssueIdentification()|escape}</div>
			{include file="frontend/objects/issue_toc.tpl" heading="h3"}
			<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}" class="read_more">
				{translate key="journal.viewAllIssues"}
			</a>
		</section>
	{/if}

	{* Additional Homepage Content (still supported) *}
	{if $additionalHomeContent}
		<div class="additional_content">{$additionalHomeContent}</div>
	{/if}
	
	
	
	{* ===== FAQ  ===== *}
	<section class="lrsj-faq" id="faq">
	  <div class="pkp_container">
		<div class="lrsj-center mb-12">
		  <h2 class="lrsj-h2">Frequently Asked Questions</h2>
		  <p class="lrsj-lead">Find answers to common questions about submitting to the Lehigh Rising Scholars Journal</p>
		</div>

		<div class="lrsj-faq-list">
		  <details class="lrsj-faq-item">
			<summary>Who can submit to the journal?</summary>
			<div><p>The Lehigh Rising Scholars Journal accepts submissions from undergraduate and graduate students at accredited institutions worldwide. Faculty submissions are also welcome for special issues or as invited contributions.</p></div>
		  </details>

		  <details class="lrsj-faq-item">
			<summary>What types of articles do you accept?</summary>
			<div><p>We accept original research articles, review articles, case studies, and theoretical papers across all academic disciplines. Manuscripts should be between 3,000–8,000 words (excluding references) and follow our formatting guidelines.</p></div>
		  </details>

		  <details class="lrsj-faq-item">
			<summary>How long does the review process take?</summary>
			<div><p>The initial editorial screening typically takes 1–2 weeks. If your manuscript passes this stage, the full peer review process usually takes 6–8 weeks. During peak submission periods, it may take slightly longer.</p></div>
		  </details>

		  <details class="lrsj-faq-item">
			<summary>Is there a publication fee?</summary>
			<div><p>There is no fee to submit or publish in the Lehigh Rising Scholars Journal. We are committed to open access and supported by Lehigh University's Office of Research.</p></div>
		  </details>

		  <details class="lrsj-faq-item">
			<summary>Can I submit work that's been published elsewhere?</summary>
			<div><p>We only accept original, unpublished work. Preprints and conference versions are fine if they haven’t appeared in another peer-reviewed journal.</p></div>
		  </details>
		</div>
	  </div>
	</section>
	
	{* Call to Action *}
	<section class="lrsj-cta">
	  <div class="pkp_container lrsj-center">
		<h2 class="lrsj-cta-title">Ready To Submit Your Research?</h2>
		<p class="lrsj-cta-text">Join our community of rising scholars and contribute to the advancement of knowledge across disciplines.</p>
		<a href="{url page='about' op='submissions'}" class="lrsj-cta-btn">Start Your Submission</a>
	  </div>
	</section>
</div>



{include file="frontend/components/footer.tpl"}
