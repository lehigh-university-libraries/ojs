{**
 * templates/frontend/pages/about.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view a journal's or press's description, contact
 *  details, policies and more.
 *
 * @uses $currentContext Journal|Press The current journal or press
 *}
{include file="frontend/components/header.tpl" pageTitle="about.aboutContext"}

<div class="page page_about">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.aboutContext"}
	{* <h1>{translate key="about.aboutContext"}</h1> *}

	{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.aboutContext"}

	{* ===== About & Scope Shared Box ===== *}
	<section class="lrsj-about-card">
	  <h1>About the Journal</h1>
	  <p>
		The <em>Lehigh Rising Scholars Journal (LRSJ)</em> is a student-run, peer-reviewed academic journal dedicated to publishing high-quality research from emerging scholars across all disciplines. Each submission undergoes a rigorous review process by graduate student reviewers to ensure academic excellence and integrity.
	  </p>

	  <h2>Focus &amp; Scope</h2>
	  <p>
		Our mission is to provide a platform for undergraduate and graduate students to share their work, gain valuable peer-review experience, and contribute to the academic community.
	  </p>
	  
	  <p><strong>
		If you are interested in submitting papers for review, please 
		<a href="{url page="user" op="register"}">register as an author</a> 
		and <a href="{url page="submission"}">submit your paper(s) through the system</a>.</strong>
	  </p>
	  
	  <p><strong>
		  If you are interested in joining as a reviewer, please email 
		  <a href="mailto:inlrsj@lehigh.edu">inlrsj@lehigh.edu</a> 
		  to request the Peer Reviewer Questionnaire and begin the reviewer application process.</strong>
	  </p>
	</section>
	
	{* ===== Peer Review Process ===== *}
	<section id="peerreview">
		<h2>Peer Review Process</h2>
		<p>
			The <em>Lehigh Rising Scholars Journal</em> is a peer-reviewed academic journal dedicated to showcasing undergraduate research within the Lehigh University community. Our review process is designed not only to ensure scholarly merit, but also to foster growth, confidence, and academic curiosity among undergraduate authors.
		</p>
		<p>
			Manuscripts are evaluated by graduate student reviewers with relevant expertise. Reviewers provide constructive and encouraging feedback that highlights strengths and offers clear, actionable suggestions for improvement. This developmental approach helps familiarize undergraduate authors with the peer review process and prepares them for future publication experiences.
		</p>
		<p>
			At LRSJ, peer review serves both an evaluative and educational role. We rely on the thoughtful and professional contributions of our reviewers to uphold academic rigor and clarity, while promoting constructive academic exchange and supporting an inclusive intellectual community. Reviewers are expected to provide feedback that is specific, respectful, and developmentally focused.
		</p>
	</section>

	{* ===== Open Access Policy ===== *}
	<section id="open-access">
		<h2>Open Access Policy</h2>
		<p>
			The <em>LRSJ</em> is an open access journal. 
			All published articles are freely available online for reading, downloading, and sharing at no cost.
		</p>
		<p>
			There are no submission or publication fees for authors. Authors retain copyright of their work and 
			grant the journal the right of first publication. The journal is supported by Lehigh University and run by students as part of our mission to promote accessible scholarly communication.
		</p>
		<p>
			Readers may read, download, copy, distribute, print, search, or link to the full texts of articles without asking prior permission from the publisher or the authors.
		</p>
	</section>

	{* ===== General Ethics Policy ===== *}
	<section id="ethics">
		<h2>Ethics Policy</h2>
		<p>
			The <em>LRSJ</em> is committed to upholding high standards of publishing ethics. 
			All submissions must be original work, not under consideration elsewhere. 
			Authors must disclose conflicts of interest, and research involving humans or animals 
			must have appropriate ethical approvals. 
		</p>
	</section>
	
	{* ===== Ethical Considerations for Authors ===== *}
	<section id="author-ethics">
	  <h2>Ethical Considerations for Authors</h2>

	  <div class="lrsj-faq-list">

		<!-- Academic Integrity -->
		<details class="lrsj-faq-item">
		  <summary>Academic Integrity</summary>
		  <div>
			<p>The <em>Lehigh Rising Scholars Journal (LRSJ)</em> upholds Lehigh University’s
			standards of academic integrity and requires all submissions to reflect originality
			and intellectual honesty.</p>
			<ul>
			  <li>Submit only your own work and provide clear acknowledgment when building on the ideas or words of others.</li>
			  <li>Avoid plagiarism, falsification of data, and unauthorized collaboration.</li>
			  <li>Cite all sources appropriately, including the use of generative AI tools when relevant.</li>
			  <li>Ensure that any use of generative AI is transparent, cited according to journal guidelines, and verified against reputable scholarly sources.</li>
			</ul>
		  </div>
		</details>

		<!-- Proper Use of Sources -->
		<details class="lrsj-faq-item">
		  <summary>Proper Use of Sources</summary>
		  <div>
			<p>Authors must demonstrate integrity in how they use and cite information:</p>
			<ul>
			  <li>Always attribute ideas, data, and quotations to their original sources.</li>
			  <li>Use discipline-appropriate citation styles consistently.</li>
			  <li>Consult <a href="http://libraryguides.lehigh.edu/plagiarism">Lehigh Library’s Proper Use of Information</a> for detailed guidance.</li>
			</ul>
		  </div>
		</details>

		<!-- Generative AI -->
		<details class="lrsj-faq-item">
		  <summary>Use of Generative AI</summary>
		  <div>
			<p>Generative AI can be a useful tool for idea exploration, but its outputs are often unreliable. Authors must:</p>
			<ul>
			  <li>Clearly indicate when generative AI has been used in the preparation of a manuscript.</li>
			  <li>Provide appropriate citations for AI use according to journal guidelines.</li>
			  <li>Cross-check AI-generated material against reputable, peer-reviewed sources for accuracy.</li>
			</ul>
		  </div>
		</details>

		<!-- Alignment with University Policies -->
		<details class="lrsj-faq-item">
		  <summary>Alignment with University Policies</summary>
		  <div>
			<p>All submissions must comply with Lehigh University’s academic integrity standards.
			Authors are encouraged to review the following resources:</p>
			<ul>
			  <li><a href="http://libraryguides.lehigh.edu/plagiarism">Lehigh Library’s Proper Use of Information</a></li>
			  <li><a href="https://studentaffairs.lehigh.edu/content/code-conduct">Lehigh University Code of Conduct</a></li>
			</ul>
		  </div>
		</details>

	  </div>
	</section>

	{* ===== Ethical Considerations for Peer Reviewers ===== *}
	<section id="review-ethics">
	  <h2>Ethical Considerations for Peer Reviewers</h2>

	  <div class="lrsj-faq-list">

		<!-- Confidentiality -->
		<details class="lrsj-faq-item">
		  <summary>Confidentiality</summary>
		  <div>
			<ul>
			  <li>Confidentiality must be maintained throughout the review process.</li>
			  <li>Manuscript contents, data, and author identities may <strong>not</strong> be shared with anyone.</li>
			</ul>
		  </div>
		</details>

		<!-- Conflicts of Interest -->
		<details class="lrsj-faq-item">
		  <summary>Conflicts of Interest</summary>
		  <div>
			<p>A conflict of interest includes, but is not limited to:</p>
			<ul>
			  <li>Having any personal or professional connection to the authors</li>
			  <li>Being engaged in nearly identical research</li>
			</ul>
			<p>If a conflict occurs, reviewers must recuse themselves to ensure fairness.</p>
		  </div>
		</details>

		<!-- Avoiding Bias -->
		<details class="lrsj-faq-item">
		  <summary>Avoiding Bias</summary>
		  <div>
			<p>Bias can include, but is not limited to:</p>
			<ul>
			  <li><em>Ad hominem</em> – assumptions about the author’s gender, race, etc.</li>
			  <li><em>Affiliation</em> – assumptions based on the author’s lab, professor, or institution</li>
			  <li><em>Ideological</em> – the reviewer’s personal beliefs or worldview</li>
			  <li><em>Aesthetic</em> – subjective judgments about style, visuals, or language</li>
			</ul>
		  </div>
		</details>

		<!-- Integrity & Professionalism -->
		<details class="lrsj-faq-item">
		  <summary>Integrity & Professionalism</summary>
		  <div>
			<ul>
			  <li>Accept review invitations only when you have sufficient expertise and time to complete them responsibly.</li>
			  <li>Read the manuscript thoroughly and provide constructive, respectful, and specific feedback.</li>
			  <li>Base comments and conclusions only on originality, quality, and merit.</li>
			</ul>
		  </div>
		</details>

	  </div>
	</section>

</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
