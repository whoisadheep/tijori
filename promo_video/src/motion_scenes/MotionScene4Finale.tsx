import React from 'react';
import { interpolate, useCurrentFrame, Easing } from 'remotion';
import { colors, fonts } from '../theme';
import { Background } from '../components/Background';

/**
 * Scene 4: Kinetic Typography & Brand Climax
 * Motion Principles Applied:
 * - Brand Motion Identity: Signature easing (0.4, 0, 0.2, 1)
 * - Kinetic Typography: Tracking compression (18px -> 4px)
 * - Staggered Chip Cascade: 3 pills with 35ms micro-delay (< 180ms total budget)
 * - Ambient CTA Breathing: Sine oscillation (0.985 - 1.015, 2500ms cycle)
 * - Specular gleam across hero action
 */
export const MotionScene4Finale: React.FC = () => {
  const frame = useCurrentFrame();

  // --- BRAND TITLE ENTRANCE (Frames 0 - 35) ---
  const titleY = interpolate(frame, [0, 32], [30, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.4, 0, 0.2, 1),
  });
  const titleOpacity = interpolate(frame, [0, 24], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });
  const tracking = interpolate(frame, [0, 50], [18, 5], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.4, 0, 0.2, 1),
  });

  // --- FEATURE CHIPS MICRO-STAGGER (< 180ms total budget) ---
  const chip1Y = interpolate(frame, [25, 45], [20, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });
  const chip1Opacity = interpolate(frame, [25, 40], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const chip2Y = interpolate(frame, [35, 55], [20, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });
  const chip2Opacity = interpolate(frame, [35, 50], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const chip3Y = interpolate(frame, [45, 65], [20, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });
  const chip3Opacity = interpolate(frame, [45, 60], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // --- AMBIENT BREATHING CTA (Frames 60 - 120) ---
  // Sine scale oscillation 0.985 - 1.015 (never > ±5%)
  const ctaBreathing = 1 + Math.sin(frame / 12) * 0.015;

  const ctaEntranceY = interpolate(frame, [50, 75], [25, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.4, 0, 0.2, 1),
  });
  const ctaEntranceOpacity = interpolate(frame, [50, 70], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Shimmer Gleam across CTA
  const gleamX = interpolate(frame, [70, 105], [-100, 200], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  return (
    <div
      style={{
        width: 1920,
        height: 1080,
        position: 'relative',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        overflow: 'hidden',
      }}
    >
      <Background accentColor={colors.champagneGold} />

      {/* Motion Skill Annotation Overlay */}
      <div
        style={{
          position: 'absolute',
          top: 50,
          left: 60,
          display: 'flex',
          gap: 16,
          zIndex: 30,
        }}
      >
        <div
          style={{
            padding: '8px 18px',
            backgroundColor: 'rgba(212, 175, 55, 0.12)',
            border: `1px solid ${colors.goldBorder}`,
            borderRadius: 8,
            backdropFilter: 'blur(8px)',
            display: 'flex',
            alignItems: 'center',
            gap: 10,
          }}
        >
          <div
            style={{
              width: 8,
              height: 8,
              borderRadius: '50%',
              backgroundColor: colors.champagneGold,
              boxShadow: `0 0 10px ${colors.champagneGold}`,
            }}
          />
          <span
            style={{
              color: colors.champagneGold,
              fontFamily: fonts.mono,
              fontSize: 13,
              fontWeight: 600,
              letterSpacing: 2,
            }}
          >
            ACT IV: AMBIENT BREATHING & RADIAL FOCUS
          </span>
        </div>

        <div
          style={{
            padding: '8px 18px',
            backgroundColor: 'rgba(255, 255, 255, 0.05)',
            border: '1px solid rgba(255, 255, 255, 0.15)',
            borderRadius: 8,
            backdropFilter: 'blur(8px)',
          }}
        >
          <span
            style={{
              color: colors.creamMuted,
              fontFamily: fonts.mono,
              fontSize: 13,
              letterSpacing: 1.5,
            }}
          >
            SINE OSCILLATION (±1.5%) · KINETIC TYPOGRAPHY
          </span>
        </div>
      </div>

      {/* Hero Brand Title */}
      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          transform: `translateY(${titleY}px)`,
          opacity: titleOpacity,
        }}
      >
        <div
          style={{
            fontFamily: fonts.serif,
            fontSize: 78,
            fontWeight: 900,
            color: colors.champagneLight,
            letterSpacing: tracking,
            textShadow:
              '0 8px 30px rgba(0, 0, 0, 0.9), 0 0 40px rgba(212, 175, 55, 0.35)',
          }}
        >
          TIJORI
        </div>

        <div
          style={{
            marginTop: 10,
            fontFamily: fonts.sans,
            fontSize: 24,
            fontWeight: 400,
            color: colors.creamMuted,
            letterSpacing: 4,
            textTransform: 'uppercase',
          }}
        >
          The Operating System for Elite Jewellers
        </div>
      </div>

      {/* Micro-Staggered Value Proposition Chips */}
      <div
        style={{
          marginTop: 48,
          display: 'flex',
          gap: 20,
        }}
      >
        {/* Chip 1 */}
        <div
          style={{
            padding: '16px 28px',
            backgroundColor: 'rgba(38, 24, 20, 0.9)',
            border: `1px solid ${colors.goldBorder}`,
            borderRadius: 14,
            display: 'flex',
            alignItems: 'center',
            gap: 12,
            transform: `translateY(${chip1Y}px)`,
            opacity: chip1Opacity,
            boxShadow: '0 10px 25px rgba(0, 0, 0, 0.5)',
          }}
        >
          <span style={{ fontSize: 20 }}>⚡</span>
          <span
            style={{
              fontFamily: fonts.sans,
              color: colors.cream,
              fontSize: 16,
              fontWeight: 600,
            }}
          >
            100% Offline SQLite Engine
          </span>
        </div>

        {/* Chip 2 */}
        <div
          style={{
            padding: '16px 28px',
            backgroundColor: 'rgba(38, 24, 20, 0.9)',
            border: `1px solid ${colors.goldBorder}`,
            borderRadius: 14,
            display: 'flex',
            alignItems: 'center',
            gap: 12,
            transform: `translateY(${chip2Y}px)`,
            opacity: chip2Opacity,
            boxShadow: '0 10px 25px rgba(0, 0, 0, 0.5)',
          }}
        >
          <span style={{ fontSize: 20 }}>⚖️</span>
          <span
            style={{
              fontFamily: fonts.sans,
              color: colors.cream,
              fontSize: 16,
              fontWeight: 600,
            }}
          >
            Pure Karigar Metal Ledger
          </span>
        </div>

        {/* Chip 3 */}
        <div
          style={{
            padding: '16px 28px',
            backgroundColor: 'rgba(38, 24, 20, 0.9)',
            border: `1px solid ${colors.goldBorder}`,
            borderRadius: 14,
            display: 'flex',
            alignItems: 'center',
            gap: 12,
            transform: `translateY(${chip3Y}px)`,
            opacity: chip3Opacity,
            boxShadow: '0 10px 25px rgba(0, 0, 0, 0.5)',
          }}
        >
          <span style={{ fontSize: 20 }}>🧾</span>
          <span
            style={{
              fontFamily: fonts.sans,
              color: colors.cream,
              fontSize: 16,
              fontWeight: 600,
            }}
          >
            Thermal POS & GST Ready
          </span>
        </div>
      </div>

      {/* Ambient Breathing CTA Button */}
      <div
        style={{
          marginTop: 52,
          transform: `translateY(${ctaEntranceY}px) scale(${ctaBreathing})`,
          opacity: ctaEntranceOpacity,
          position: 'relative',
        }}
      >
        <div
          style={{
            padding: '22px 56px',
            borderRadius: 16,
            background: 'linear-gradient(135deg, #F3D270 0%, #B88E1C 100%)',
            boxShadow:
              '0 15px 40px rgba(212, 175, 55, 0.4), 0 0 50px rgba(212, 175, 55, 0.25)',
            display: 'flex',
            alignItems: 'center',
            gap: 16,
            position: 'relative',
            overflow: 'hidden',
          }}
        >
          {/* Specular Shimmer Sweep */}
          <div
            style={{
              position: 'absolute',
              top: 0,
              left: `${gleamX}%`,
              width: 90,
              height: '100%',
              background:
                'linear-gradient(90deg, transparent 0%, rgba(255, 255, 255, 0.5) 50%, transparent 100%)',
              transform: 'skewX(-25deg)',
              pointerEvents: 'none',
            }}
          />

          <span
            style={{
              fontFamily: fonts.sans,
              fontSize: 22,
              fontWeight: 800,
              color: '#1A0F0A',
              letterSpacing: 2,
            }}
          >
            BOOK YOUR PRIVATE DEMO
          </span>
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
            <path
              d="M5 12H19"
              stroke="#1A0F0A"
              strokeWidth="2.5"
              strokeLinecap="round"
            />
            <path
              d="M12 5L19 12L12 19"
              stroke="#1A0F0A"
              strokeWidth="2.5"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
          </svg>
        </div>
      </div>
    </div>
  );
};