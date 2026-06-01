// Cyberpunk Neon Background Matrix Effect
// Written in JavaScript for high performance Web Canvas integration

window.CyberBg = {
    canvas: null,
    ctx: null,
    particles: [],
    animationId: null,
    isActive: false,

    start: function() {
        if (this.isActive) return;
        this.isActive = true;
        
        this.canvas = document.createElement('canvas');
        this.canvas.id = 'cyber-canvas';
        this.canvas.style.position = 'fixed';
        this.canvas.style.top = '0';
        this.canvas.style.left = '0';
        this.canvas.style.width = '100vw';
        this.canvas.style.height = '100vh';
        this.canvas.style.zIndex = '-1';
        this.canvas.style.pointerEvents = 'none';
        this.canvas.style.opacity = '0.3';
        document.body.appendChild(this.canvas);
        
        this.ctx = this.canvas.getContext('2d');
        this.resize();
        window.addEventListener('resize', this.resize.bind(this));
        
        this.initParticles();
        this.animate();
    },

    stop: function() {
        this.isActive = false;
        if (this.animationId) cancelAnimationFrame(this.animationId);
        if (this.canvas && this.canvas.parentNode) {
            this.canvas.parentNode.removeChild(this.canvas);
        }
        window.removeEventListener('resize', this.resize.bind(this));
    },

    resize: function() {
        if (!this.canvas) return;
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
    },

    initParticles: function() {
        this.particles = [];
        const numParticles = Math.floor((window.innerWidth * window.innerHeight) / 15000);
        for (let i = 0; i < numParticles; i++) {
            this.particles.push({
                x: Math.random() * window.innerWidth,
                y: Math.random() * window.innerHeight,
                radius: Math.random() * 2 + 1,
                vx: Math.random() * 1 - 0.5,
                vy: Math.random() * 1 - 0.5,
                color: Math.random() > 0.5 ? '#7C3AED' : '#22D3EE' // Purple or Cyan
            });
        }
    },

    animate: function() {
        if (!this.isActive) return;
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        
        for (let i = 0; i < this.particles.length; i++) {
            let p = this.particles[i];
            
            p.x += p.vx;
            p.y += p.vy;
            
            if (p.x < 0 || p.x > this.canvas.width) p.vx *= -1;
            if (p.y < 0 || p.y > this.canvas.height) p.vy *= -1;
            
            this.ctx.beginPath();
            this.ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
            this.ctx.fillStyle = p.color;
            this.ctx.fill();
            
            // Draw connections
            for (let j = i + 1; j < this.particles.length; j++) {
                let p2 = this.particles[j];
                let dist = Math.sqrt(Math.pow(p.x - p2.x, 2) + Math.pow(p.y - p2.y, 2));
                
                if (dist < 150) {
                    this.ctx.beginPath();
                    this.ctx.moveTo(p.x, p.y);
                    this.ctx.lineTo(p2.x, p2.y);
                    this.ctx.strokeStyle = p.color + Math.floor((1 - dist/150) * 255).toString(16).padStart(2, '0');
                    this.ctx.lineWidth = 0.5;
                    this.ctx.stroke();
                }
            }
        }
        
        this.animationId = requestAnimationFrame(this.animate.bind(this));
    }
};
