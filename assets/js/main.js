/* =============================================================
   Little Juneberry Photography site interactions
   Mobile nav · header scroll state · scroll reveal ·
   FAQ accordion · back-to-top · portfolio filter + lightbox
   ============================================================= */
(function () {
  'use strict';

  document.addEventListener('DOMContentLoaded', function () {
    initNav();
    initHeaderScroll();
    initReveal();
    initFaq();
    initBackToTop();
    initGalleryFilter();
    initLightbox();
    markActiveNav();
  });

  /* ---------- Mobile navigation ---------- */
  function initNav() {
    var toggle = document.getElementById('nav-toggle');
    var nav = document.getElementById('primary-nav');
    var backdrop = document.getElementById('nav-backdrop');
    if (!toggle || !nav) return;

    function close() {
      nav.classList.remove('is-open');
      toggle.setAttribute('aria-expanded', 'false');
      toggle.setAttribute('aria-label', 'Open menu');
      document.body.classList.remove('nav-open');
      if (backdrop) backdrop.classList.remove('is-visible');
    }
    function open() {
      nav.classList.add('is-open');
      toggle.setAttribute('aria-expanded', 'true');
      toggle.setAttribute('aria-label', 'Close menu');
      document.body.classList.add('nav-open');
      if (backdrop) backdrop.classList.add('is-visible');
    }

    toggle.addEventListener('click', function () {
      nav.classList.contains('is-open') ? close() : open();
    });
    if (backdrop) backdrop.addEventListener('click', close);
    nav.querySelectorAll('a').forEach(function (link) {
      link.addEventListener('click', close);
    });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') close();
    });
  }

  /* ---------- Header: transparent → solid on scroll ---------- */
  function initHeaderScroll() {
    var header = document.getElementById('site-header');
    if (!header || header.classList.contains('header--solid')) return;
    var onScroll = function () {
      header.classList.toggle('is-scrolled', window.scrollY > 60);
    };
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
  }

  /* ---------- Scroll reveal ---------- */
  function initReveal() {
    var els = document.querySelectorAll('.reveal');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
      els.forEach(function (el) { el.classList.add('is-visible'); });
      return;
    }
    var io = new IntersectionObserver(function (entries, obs) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          obs.unobserve(entry.target);
        }
      });
    }, { rootMargin: '0px 0px -8% 0px', threshold: 0.08 });
    els.forEach(function (el) { io.observe(el); });
  }

  /* ---------- FAQ accordion ---------- */
  function initFaq() {
    var items = document.querySelectorAll('.faq-item');
    items.forEach(function (item) {
      var q = item.querySelector('.faq-item__q');
      var a = item.querySelector('.faq-item__a');
      if (!q || !a) return;
      q.addEventListener('click', function () {
        var isOpen = item.classList.contains('is-open');
        // close siblings for a clean accordion
        items.forEach(function (other) {
          if (other !== item) {
            other.classList.remove('is-open');
            var oa = other.querySelector('.faq-item__a');
            var oq = other.querySelector('.faq-item__q');
            if (oa) oa.style.maxHeight = null;
            if (oq) oq.setAttribute('aria-expanded', 'false');
          }
        });
        if (isOpen) {
          item.classList.remove('is-open');
          a.style.maxHeight = null;
          q.setAttribute('aria-expanded', 'false');
        } else {
          item.classList.add('is-open');
          a.style.maxHeight = a.scrollHeight + 'px';
          q.setAttribute('aria-expanded', 'true');
        }
      });
    });
  }

  /* ---------- Back to top ---------- */
  function initBackToTop() {
    var btn = document.getElementById('to-top');
    if (!btn) return;
    window.addEventListener('scroll', function () {
      btn.classList.toggle('is-visible', window.scrollY > 600);
    }, { passive: true });
    btn.addEventListener('click', function () {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  /* ---------- Portfolio category filter ---------- */
  function initGalleryFilter() {
    var filters = document.querySelectorAll('.gallery-filters button');
    var items = document.querySelectorAll('.masonry__item');
    if (!filters.length || !items.length) return;
    filters.forEach(function (btn) {
      btn.addEventListener('click', function () {
        filters.forEach(function (b) { b.classList.remove('is-active'); });
        btn.classList.add('is-active');
        var cat = btn.getAttribute('data-filter');
        items.forEach(function (item) {
          var show = cat === 'all' || item.getAttribute('data-cat') === cat;
          item.classList.toggle('is-hidden', !show);
        });
      });
    });
  }

  /* ---------- Lightbox ---------- */
  function initLightbox() {
    var triggers = Array.prototype.slice.call(document.querySelectorAll('[data-lightbox]'));
    if (!triggers.length) return;

    var box = document.createElement('div');
    box.className = 'lightbox';
    box.setAttribute('role', 'dialog');
    box.setAttribute('aria-modal', 'true');
    box.setAttribute('aria-label', 'Image viewer');
    box.innerHTML =
      '<button class="lightbox__btn lightbox__close" aria-label="Close">&times;</button>' +
      '<button class="lightbox__btn lightbox__prev" aria-label="Previous image"><svg class="ic" aria-hidden="true"><use href="#ic-chevron-left"></use></svg></button>' +
      '<figure class="lightbox__figure"><img alt=""><figcaption class="lightbox__caption"></figcaption></figure>' +
      '<button class="lightbox__btn lightbox__next" aria-label="Next image"><svg class="ic" aria-hidden="true"><use href="#ic-chevron-right"></use></svg></button>' +
      '<div class="lightbox__count"></div>';
    document.body.appendChild(box);

    var imgEl = box.querySelector('img');
    var captionEl = box.querySelector('.lightbox__caption');
    var countEl = box.querySelector('.lightbox__count');
    var current = 0;
    var lastList = [];

    function preload(src) { if (src) { var i = new Image(); i.src = src; } }

    function visibleTriggers() {
      return triggers.filter(function (t) {
        var item = t.closest('.masonry__item');
        return !item || !item.classList.contains('is-hidden');
      });
    }

    function fullSrc(t) { return t.getAttribute('data-lightbox') || t.querySelector('img').src; }

    function show(list, index) {
      lastList = list;
      current = (index + list.length) % list.length;
      var t = list[current];
      var alt = t.querySelector('img') ? t.querySelector('img').alt : '';
      imgEl.src = fullSrc(t);
      imgEl.alt = alt;
      captionEl.textContent = alt;
      countEl.textContent = (current + 1) + ' / ' + list.length;
      // Preload neighbours so prev/next feels instant
      if (list.length > 1) {
        preload(fullSrc(list[(current + 1) % list.length]));
        preload(fullSrc(list[(current - 1 + list.length) % list.length]));
      }
    }

    function open(t) {
      var list = visibleTriggers();
      var index = list.indexOf(t);
      show(list, index < 0 ? 0 : index);
      box.classList.add('is-open');
      document.body.style.overflow = 'hidden';
    }
    function close() {
      box.classList.remove('is-open');
      document.body.style.overflow = '';
    }
    function step(dir) { show(visibleTriggers(), current + dir); }

    triggers.forEach(function (t) {
      t.addEventListener('click', function (e) {
        e.preventDefault();
        open(t);
      });
    });
    box.querySelector('.lightbox__close').addEventListener('click', close);
    box.querySelector('.lightbox__prev').addEventListener('click', function () { step(-1); });
    box.querySelector('.lightbox__next').addEventListener('click', function () { step(1); });
    box.addEventListener('click', function (e) { if (e.target === box) close(); });
    document.addEventListener('keydown', function (e) {
      if (!box.classList.contains('is-open')) return;
      if (e.key === 'Escape') close();
      if (e.key === 'ArrowLeft') step(-1);
      if (e.key === 'ArrowRight') step(1);
    });

    // Touch swipe (mobile)
    var touchX = null;
    box.addEventListener('touchstart', function (e) { touchX = e.changedTouches[0].clientX; }, { passive: true });
    box.addEventListener('touchend', function (e) {
      if (touchX === null) return;
      var dx = e.changedTouches[0].clientX - touchX;
      if (Math.abs(dx) > 50) step(dx < 0 ? 1 : -1);
      touchX = null;
    }, { passive: true });
  }

  /* ---------- Mark active nav item (fallback if not hard-coded) ---------- */
  function markActiveNav() {
    var path = window.location.pathname.split('/').pop() || 'index.html';
    document.querySelectorAll('.nav__link').forEach(function (link) {
      var href = link.getAttribute('href');
      if (href === path && !link.hasAttribute('aria-current')) {
        link.setAttribute('aria-current', 'page');
      }
    });
  }
})();
