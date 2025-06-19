// Include system for loading common elements
document.addEventListener('DOMContentLoaded', function() {
    // Determine the correct path based on current location
    const isInSubfolder = window.location.pathname.includes('/pages/');
    const includePath = isInSubfolder ? '../includes/' : 'includes/';
      // Load header
    const headerPlaceholder = document.getElementById('header-placeholder');
    if (headerPlaceholder) {
        const headerFile = isInSubfolder ? 'header-pages.html' : 'header.html';
        fetch(includePath + headerFile)
            .then(response => response.text())
            .then(data => {
                headerPlaceholder.innerHTML = data;
                // Set active page in navigation
                setActivePage();
                // Initialize dropdown functionality
                initializeDropdowns();
            })
            .catch(error => console.error('Error loading header:', error));
    }

    // Load footer
    const footerPlaceholder = document.getElementById('footer-placeholder');
    if (footerPlaceholder) {
        fetch(includePath + 'footer.html')
            .then(response => response.text())
            .then(data => {
                footerPlaceholder.innerHTML = data;
            })
            .catch(error => console.error('Error loading footer:', error));
    }
});

// Set active page in navigation
function setActivePage() {
    const currentPage = window.location.pathname.split('/').pop();
    const navLinks = document.querySelectorAll('.nav-links a');
    
    navLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href === currentPage || (currentPage === '' && href === 'index.html')) {
            link.setAttribute('aria-current', 'page');
            link.classList.add('active');
        }
    });
}

// Initialize dropdown functionality
function initializeDropdowns() {
    const dropdowns = document.querySelectorAll('.dropdown');
    
    dropdowns.forEach(dropdown => {
        const trigger = dropdown.querySelector('a[aria-haspopup="true"]');
        const menu = dropdown.querySelector('.dropdown-content');
        
        if (trigger && menu) {
            // Handle click
            trigger.addEventListener('click', function(e) {
                e.preventDefault();
                const isExpanded = trigger.getAttribute('aria-expanded') === 'true';
                trigger.setAttribute('aria-expanded', !isExpanded);
                menu.style.display = isExpanded ? 'none' : 'block';
            });
            
            // Handle keyboard navigation
            trigger.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    trigger.click();
                }
            });
            
            // Close dropdown when clicking outside
            document.addEventListener('click', function(e) {
                if (!dropdown.contains(e.target)) {
                    trigger.setAttribute('aria-expanded', 'false');
                    menu.style.display = 'none';
                }
            });
        }
    });
}