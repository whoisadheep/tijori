import React from 'react';
import { interpolate, useCurrentFrame, Easing } from 'remotion';
import { colors, fonts } from '../theme';
import { Background } from '../components/Background';

/**
 * Scene 1: The Golden Vault & Three Pillars
 * Motion Personality: Premium (Duration 350-600ms, cubic-bezier(0.4, 0, 0.2, 1), 0% overshoot)
 * Disney Principles: Anticipation, Staging, Secondary Motion (Gleam Shimmer + Shadow Lag)
 */
export const MotionScene1Vault: React.FC = () => {
  const frame = useCurrentFrame();

  // --- AMBIENT LAYER (Layer 3) ---
  // Background radial breathing: subtle 0.98 -> 1.02 oscillation (sine wave)
  const ambientScale = 1 + Math.sin(frame / 20) * 0.015;

  // --- ANTICIPATION & HERO ENTRANCE (Layer 1 - Primary) ---
  // Anticipation: between frame 8 and 20, the vault compresses slightly (scale 0.96)
  // Action: between frame 20 and 55, expands with signature Premium easing
  const anticipationScale = interpolate(frame, [8, 18], [1, 0.96], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  const launchScale = interpolate(frame, [18, 55], [0.96, 1.0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.4, 0, 0.2, 1), // Premium signature easing
  });

  const currentScale = frame < 18 ? anticipationScale : launchScale;

  // Rotation: Anticipation backs up by -8 degrees, then spins cleanly to 0
  const anticipationRot = interpolate(frame, [8, 18], [0, -8], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });
  const launchRot = interpolate(frame, [18, 55], [-8, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.4, 0, 0.2, 1),
  });
  const rotation = frame < 18 ? anticipationRot : launchRot;

  // --- SECONDARY LAYER (Layer 2) ---
  // Follow-through: Shadow arrives 50ms (1.5 frames) after card settles
  const shadowSpread = interpolate(frame, [22, 60], [10, 50], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.4, 0, 0.2, 1),
  });
  const shadowOpacity = interpolate(frame, [22, 60], [0.2, 0.6], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Gleam/Shimmer sweep: 45° metallic reflection sweep from left to right (frames 45 to 80)
  const shimmerPos = interpolate(frame, [45, 80], [-150, 250], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.inOut(Easing.cubic),
  });

  // Kinetic Typography: Staggered tracking from 14px -> 4px
  const letterSpacing = interpolate(frame, [30, 75], [16, 5], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.4, 0, 0.2, 1),
  });
  const textOpacity = interpolate(frame, [25, 55], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Badge pill entrance
  const badgeY = interpolate(frame, [10, 40], [20, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.4, 0, 0.2, 1),
  });
  const badgeOpacity = interpolate(frame, [10, 35], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Graceful exit dissolve (frames 105 - 120)
  const sceneOpacity = interpolate(frame, [105, 120], [1, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.in(Easing.cubic),
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
        opacity: sceneOpacity,
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
            PILLAR I: EMOTIONAL INTENT → LUXURY & TRUST
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
            ARCHETYPE: PREMIUM [cubic-bezier(0.4, 0, 0.2, 1)]
          </span>
        </div>
      </div>

      {/* Center Hero Vault Dial (Primary + Secondary + Ambient) */}
      <div
        style={{
          transform: `scale(${currentScale * ambientScale}) rotate(${rotation}deg)`,
          position: 'relative',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        {/* Secondary: Dynamic Delayed Shadow */}
        <div
          style={{
            position: 'absolute',
            width: 380,
            height: 380,
            borderRadius: '50%',
            boxShadow: `0 25px ${shadowSpread}px rgba(0, 0, 0, 0.8), 0 0 60px rgba(212, 175, 55, ${shadowOpacity})`,
            zIndex: 1,
          }}
        />

        {/* Dial Rim & Gears */}
        <div
          style={{
            position: 'relative',
            width: 360,
            height: 360,
            borderRadius: '50%',
            background: 'linear-gradient(145deg, #2A1A14 0%, #150B08 100%)',
            border: `6px solid ${colors.champagneGold}`,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            overflow: 'hidden',
            zIndex: 2,
          }}
        >
          {/* Inner concentric gold rings */}
          <div
            style={{
              position: 'absolute',
              width: 300,
              height: 300,
              borderRadius: '50%',
              border: '2px dashed rgba(212, 175, 55, 0.4)',
              transform: `rotate(${frame * 0.5}deg)`,
            }}
          />
          <div
            style={{
              position: 'absolute',
              width: 240,
              height: 240,
              borderRadius: '50%',
              border: `1px solid rgba(212, 175, 55, 0.3)`,
            }}
          />

          {/* Vault Core Icon */}
          <div
            style={{
              zIndex: 3,
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            <div
              style={{
                width: 90,
                height: 90,
                borderRadius: '50%',
                background: 'linear-gradient(135deg, #F3D270 0%, #B88E1C 100%)',
                boxShadow: 'inset 0 2px 4px rgba(255, 255, 255, 0.5), 0 8px 20px rgba(0, 0, 0, 0.6)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              <svg width="46" height="46" viewBox="0 0 24 24" fill="none">
                <path
                  d="M12 2L4 6V11C4 16.55 7.41 21.74 12 23C16.59 21.74 20 16.55 20 11V6L12 2Z"
                  fill="#1C110C"
                />
                <circle cx="12" cy="11" r="3" fill="#D4AF37" />
                <path
                  d="M12 14V17"
                  stroke="#D4AF37"
                  strokeWidth="2"
                  strokeLinecap="round"
                />
              </svg>
            </div>
            <span
              style={{
                marginTop: 14,
                fontFamily: fonts.mono,
                fontSize: 12,
                color: colors.champagneLight,
                letterSpacing: 4,
                fontWeight: 700,
              }}
            >
              24K RESERVE
            </span>
          </div>

          {/* Secondary Layer: Gleam / Specular Sweep */}
          <div
            style={{
              position: 'absolute',
              top: 0,
              left: `${shimmerPos}%`,
              width: 80,
              height: '100%',
              background:
                'linear-gradient(90deg, transparent 0%, rgba(255, 241, 197, 0.45) 50%, transparent 100%)',
              transform: 'skewX(-25deg)',
              pointerEvents: 'none',
              zIndex: 5,
            }}
          />
        </div>
      </div>

      {/* Kinetic Typography & Staging */}
      <div
        style={{
          marginTop: 48,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          opacity: textOpacity,
          transform: `translateY(${badgeY}px)`,
        }}
      >
        <div
          style={{
            fontFamily: fonts.serif,
            fontSize: 54,
            fontWeight: 800,
            color: colors.champagneLight,
            letterSpacing,
            textShadow: '0 4px 24px rgba(0, 0, 0, 0.8), 0 0 30px rgba(212, 175, 55, 0.3)',
          }}
        >
          TIJORI
        </div>

        <div
          style={{
            marginTop: 8,
            fontFamily: fonts.sans,
            fontSize: 20,
            fontWeight: 400,
            color: colors.creamMuted,
            letterSpacing: 3,
            textTransform: 'uppercase',
          }}
        >
          Jewellery ERP & Gold Loan Sanctuary
        </div>
      </div>
    </div>
  );
};