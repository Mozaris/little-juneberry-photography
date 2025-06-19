// Performance optimizations and lazy loading
document.addEventListener('DOMContentLoaded', function() {
  // Initialize performance optimizations first
  preloadCriticalImages();
  initAdvancedLazyLoading();
  
  // Initialize slideshow
  initSlideshow();
  
  // Initialize lazy loading for non-slideshow images only
  initLazyLoading();
  
  // Initialize accessibility features
  initAccessibility();
  
  // Initialize UX enhancements
  initUXEnhancements();
});

// UX Enhancements initialization
function initUXEnhancements() {
  // Back to top button
  initBackToTop();
  
  // Enhanced image loading states
  initImageLoadingStates();
  
  // Smooth scroll for anchor links
  initSmoothScroll();
  
  // Enhanced slideshow interactions
  initSlideshowEnhancements();
}

// Back to top button functionality
function initBackToTop() {
  const backToTopBtn = document.getElementById('backToTop');
  if (!backToTopBtn) return;
  
  // Show/hide based on scroll position
  window.addEventListener('scroll', throttle(() => {
    if (window.pageYOffset > 300) {
      backToTopBtn.classList.add('show');
      
      // Add pulse effect when first shown
      if (!backToTopBtn.classList.contains('pulse')) {
        backToTopBtn.classList.add('pulse');
        setTimeout(() => {
          backToTopBtn.classList.remove('pulse');
        }, 4000);
      }
    } else {
      backToTopBtn.classList.remove('show');
    }
  }, 100));
  
  // Smooth scroll to top
  backToTopBtn.addEventListener('click', () => {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  });
}

// Enhanced image loading states
function initImageLoadingStates() {
  const images = document.querySelectorAll('img');
  
  images.forEach(img => {
    if (img.complete) {
      img.classList.add('loaded');
    } else {
      img.classList.add('image-loading');
      
      img.addEventListener('load', () => {
        img.classList.remove('image-loading');
        img.classList.add('loaded');
        
        // Add a subtle fade-in effect
        img.style.opacity = '0';
        img.style.transition = 'opacity 0.3s ease';
        requestAnimationFrame(() => {
          img.style.opacity = '1';
        });
      });
      
      img.addEventListener('error', () => {
        img.classList.remove('image-loading');
        console.warn('Failed to load image:', img.src);
      });
    }
  });
}

// Smooth scroll for anchor links
function initSmoothScroll() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        e.preventDefault();
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
}

// Enhanced slideshow interactions
function initSlideshowEnhancements() {
  const slideshowContainer = document.querySelector('.slideshow-container');
  if (!slideshowContainer) return;
  
  // Pause slideshow on hover
  slideshowContainer.addEventListener('mouseenter', () => {
    if (isPlaying) {
      clearTimeout(slideInterval);
    }
  });
  
  // Resume slideshow when mouse leaves
  slideshowContainer.addEventListener('mouseleave', () => {
    if (isPlaying) {
      slideInterval = setTimeout(showSlides, 4000);
    }
  });
  
  // Keyboard navigation for slideshow
  document.addEventListener('keydown', (e) => {
    if (e.target.closest('.slideshow-container')) {
      switch(e.key) {
        case 'ArrowLeft':
          e.preventDefault();
          previousSlide();
          break;
        case 'ArrowRight':
          e.preventDefault();
          nextSlide();
          break;
        case ' ': // Spacebar
        case 'Enter':
          e.preventDefault();
          isPlaying ? pauseSlideshow() : playSlideshow();
          break;
      }
    }
  });
}

// Throttle function for performance
function throttle(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// Enhanced slideshow navigation
function nextSlide() {
  clearTimeout(slideInterval);
  showSlides();
}

function previousSlide() {
  clearTimeout(slideInterval);
  slideIndex = slideIndex - 2; // Subtract 2 because showSlides adds 1
  if (slideIndex < 0) {
    slideIndex = document.getElementsByClassName("mySlides").length - 1;
  }
  showSlides();
}

// Accessibility initialization
function initAccessibility() {
  // Dropdown keyboard navigation
  initDropdownAccessibility();
  
  // Slideshow controls
  initSlideshowControls();
  
  // Respect user's reduced motion preference
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    pauseSlideshow();
  }
}

// Dropdown accessibility
function initDropdownAccessibility() {
  const dropdownToggle = document.querySelector('.dropdown > a[aria-haspopup="true"]');
  const dropdownMenu = document.querySelector('.dropdown-content');
  
  if (dropdownToggle && dropdownMenu) {
    dropdownToggle.addEventListener('click', function(e) {
      e.preventDefault();
      const isExpanded = dropdownToggle.getAttribute('aria-expanded') === 'true';
      dropdownToggle.setAttribute('aria-expanded', !isExpanded);
    });
    
    dropdownToggle.addEventListener('keydown', function(e) {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        const isExpanded = dropdownToggle.getAttribute('aria-expanded') === 'true';
        dropdownToggle.setAttribute('aria-expanded', !isExpanded);
      }
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
      if (!e.target.closest('.dropdown')) {
        dropdownToggle.setAttribute('aria-expanded', 'false');
      }
    });
  }
}

// Slideshow controls accessibility
function initSlideshowControls() {
  const pauseBtn = document.querySelector('.slideshow-pause');
  const playBtn = document.querySelector('.slideshow-play');
  const indicators = document.querySelectorAll('.indicator');
  
  if (pauseBtn) {
    pauseBtn.addEventListener('click', pauseSlideshow);
  }
  
  if (playBtn) {
    playBtn.addEventListener('click', playSlideshow);
  }
  
  indicators.forEach((indicator, index) => {
    indicator.addEventListener('click', () => goToSlide(index));
    indicator.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        goToSlide(index);
      }
    });
  });
}

// Lazy loading functionality for images that are NOT in slideshow
function initLazyLoading() {
  const lazyImages = document.querySelectorAll('img[data-src]:not(.slideshow-image)');
  
  if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.src;
          img.classList.add('loaded');
          img.removeAttribute('data-src');
          imageObserver.unobserve(img);
        }
      });
    });
    
    lazyImages.forEach(img => imageObserver.observe(img));
  } else {
    // Fallback for older browsers
    lazyImages.forEach(img => {
      img.src = img.dataset.src;
      img.classList.add('loaded');
      img.removeAttribute('data-src');
    });
  }
}

// Slideshow functionality with accessibility improvements
let slideIndex = 0;
let slideInterval;
let isPlaying = true;

function initSlideshow() {
  showSlides();
}

function showSlides() {
  let slides = document.getElementsByClassName("mySlides");
  let indicators = document.getElementsByClassName("indicator");
  
  if (slides.length === 0) return;
  
  for (let i = 0; i < slides.length; i++) {
    slides[i].style.display = "none";
    slides[i].classList.remove("fadeIn");
    slides[i].setAttribute('aria-hidden', 'true');
  }
  
  for (let i = 0; i < indicators.length; i++) {
    indicators[i].classList.remove("active");
    indicators[i].setAttribute('aria-selected', 'false');
  }
  
  slideIndex++;
  if (slideIndex > slides.length) { 
    slideIndex = 1; 
  }
  
  const currentSlide = slides[slideIndex - 1];
  const currentIndicator = indicators[slideIndex - 1];
  
  currentSlide.style.display = "block";
  currentSlide.classList.add("fadeIn");
  currentSlide.setAttribute('aria-hidden', 'false');
  
  if (currentIndicator) {
    currentIndicator.classList.add("active");
    currentIndicator.setAttribute('aria-selected', 'true');
  }
  
  if (isPlaying) {
    slideInterval = setTimeout(showSlides, 4000);
  }
}

function goToSlide(index) {
  slideIndex = index;
  clearTimeout(slideInterval);
  showSlides();
}

function pauseSlideshow() {
  isPlaying = false;
  clearTimeout(slideInterval);
  
  const pauseBtn = document.querySelector('.slideshow-pause');
  const playBtn = document.querySelector('.slideshow-play');
  
  if (pauseBtn) pauseBtn.style.display = 'none';
  if (playBtn) playBtn.style.display = 'flex';
  
  // Announce to screen readers
  announceToScreenReader('Slideshow paused');
}

function playSlideshow() {
  isPlaying = true;
  showSlides();
  
  const pauseBtn = document.querySelector('.slideshow-pause');
  const playBtn = document.querySelector('.slideshow-play');
  
  if (pauseBtn) pauseBtn.style.display = 'flex';
  if (playBtn) playBtn.style.display = 'none';
  
  // Announce to screen readers
  announceToScreenReader('Slideshow playing');
}

// Announce changes to screen readers
function announceToScreenReader(message) {
  const announcement = document.createElement('div');
  announcement.setAttribute('aria-live', 'polite');
  announcement.setAttribute('aria-atomic', 'true');
  announcement.className = 'sr-only';
  announcement.textContent = message;
  
  document.body.appendChild(announcement);
  
  setTimeout(() => {
    document.body.removeChild(announcement);
  }, 1000);
}

// Pause slideshow when page is not visible (performance optimization)
document.addEventListener('visibilitychange', function() {
  if (document.hidden) {
    clearTimeout(slideInterval);
  } else if (isPlaying) {
    slideIndex = slideIndex || 0;
    showSlides();
  }
});

// Enhanced image loading with WebP support and better lazy loading
function createOptimizedImage(src, alt, className = '') {
  const img = document.createElement('img');
  const webpSrc = src.replace(/\.(jpg|jpeg|png)$/i, '.webp');
  
  // Create picture element for WebP support
  const picture = document.createElement('picture');
  
  // WebP source
  const webpSource = document.createElement('source');
  webpSource.srcset = webpSrc;
  webpSource.type = 'image/webp';
  
  // Fallback
  img.src = src;
  img.alt = alt;
  img.loading = 'lazy';
  img.decoding = 'async';
  if (className) img.className = className;
  
  // Add loading placeholder
  img.style.backgroundColor = '#f0f0f0';
  img.style.minHeight = '200px';
  
  // Remove placeholder on load
  img.addEventListener('load', function() {
    this.style.backgroundColor = '';
    this.style.minHeight = '';
  });
  
  picture.appendChild(webpSource);
  picture.appendChild(img);
  
  return picture;
}

// Intersection Observer for better lazy loading
function initAdvancedLazyLoading() {
  if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          if (img.dataset.src) {
            img.src = img.dataset.src;
            img.removeAttribute('data-src');
            img.classList.remove('lazy');
            observer.unobserve(img);
          }
        }
      });
    }, {
      rootMargin: '50px 0px',
      threshold: 0.01
    });

    // Observe all lazy images
    document.querySelectorAll('img[data-src]').forEach(img => {
      imageObserver.observe(img);
    });
  }
}

// Preload critical images
function preloadCriticalImages() {
  const criticalImages = [
    'assets/images/portfolio/Portfolio29.jpg',
    'assets/images/portfolio/Portfolio8.jpg',
    'assets/images/portfolio/Portfolio45.jpg'
  ];
  
  criticalImages.forEach(src => {
    const link = document.createElement('link');
    link.rel = 'preload';
    link.as = 'image';
    link.href = src;
    document.head.appendChild(link);
  });
}
