{** Custom full width footer **}
<footer class="pkp_structure_footer_wrapper">
  <div class="pkp_structure_footer">
    <div class="footer-grid">

      <!-- Col 1 -->
      <div>
        <h3 class="footer-title">Lehigh Rising Scholars Journal</h3>
        <p class="footer-text">Promoting academic excellence in engineering through peer-reviewed student research.</p>

        <div class="footer-icons">
          <a href="https://linkedin.com/" class="footer-icon-link" target="_blank" rel="noopener"><i
              class="fab fa-linkedin"></i></a>
          <a href="https://www.instagram.com/lehighrisingscholars/" class="footer-icon-link" target="_blank"
            rel="noopener"><i class="fab fa-instagram"></i></a>
        </div>
      </div>

      <!-- Col 2 -->
      <div>
        <h4 class="footer-heading">Quick Links</h4>
        <ul class="footer-list">
          <li><a class="footer-link" href="{url page="index"}">Home</a></li>
          <li><a class="footer-link" href="{url page="about"}">About</a></li>
          <li><a class="footer-link" href="{url page="about" op="submissions" }">Submit</a></li>
          <li><a class="footer-link" href="{url page="issue" op="archive" }">Archive</a></li>
          <li><a class="footer-link" href="{url page="about" op="editorialMasthead" }">Meet the Team</a></li>
        </ul>
      </div>

      <!-- Col 3 -->
      <div>
        <h4 class="footer-heading">Resources</h4>
        <ul class="footer-list">
          <li><a class="footer-link" href="{url page="about" op="submissions" }">Author Guidelines</a></li>
          <li><a class="footer-link" href="{url page="about" op="submissions" }">Style Template</a></li>
          <li><a class="footer-link" href="{url page="about"}#ethics">Ethics Policy</a></li>
          <li><a class="footer-link" href="{url page="about"}#open-access">Open Access Policy</a></li>
        </ul>
      </div>

      <!-- Col 4 -->
      <div>
        <h4 class="footer-heading">Contact</h4>
        <address class="footer-address">
          <p>Lehigh Rising Scholars Journal</p>
          <p>Lehigh University</p>
          <p>27 Memorial Drive West</p>
          <p>Bethlehem, PA 18015</p>
          <p><a class="footer-link" href="mailto:inlsrj@lehigh.edu">inLRSJ@lehigh.edu</a></p>
        </address>
      </div>
    </div>

    <!-- bottom row: copyright + small OJS logo -->
    <div class="footer-bottom">
      <p>&copy; {$smarty.now|date_format:"Y"} Lehigh Rising Scholars Journal. All rights reserved.</p>
      <div class="pkp_brand_footer">
        <a href="https://pkp.sfu.ca/ojs/" target="_blank" rel="noopener">
          <img src="{$baseUrl}/plugins/themes/lrsj/images/ojs_brand.png" alt="Open Journal Systems">
        </a>
      </div>
    </div>
  </div>
  <script src="https://www.lehigh.edu/~inltswms/include/ltstemplate/js/scripts.js"></script>
</footer>