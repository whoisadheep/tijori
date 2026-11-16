import React from 'react';
import { interpolate, useCurrentFrame, Easing } from 'remotion';
import { colors, fonts } from '../theme';
import { Background } from '../components/Background';

/**
 * Scene 2: Multi-Element Choreography & The 1/3 Rule
 * Motion Rules applied:
 * - Lead with the hero (Card lands first)
 * - 1/3 Screen distance rule (entrance travel <= 40px)
 * - Stagger budget under 350ms (3 micro-cascades @ 40ms intervals)
 * - Counter-motion: background watermark glides left at 20% speed
 * - Non-linear dynamic numeric count-up
 */
export const MotionScene2Valuation: React.FC = () => {
  const frame = useCurrentFrame();

  // --- HERO CARD ENTRANCE (Frames 0 - 35) ---
  // Distance: 35px (< 1/3 screen), Decelerate curve
  const cardY = interpolate(frame, [0, 32], [35, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.4, 0, 0.2, 1),
  });
  const cardOpacity = interpolate(frame, [0, 24], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Secondary Follow-Through: Card shadow settles 50ms later (frames 15 to 45)
  const shadowSpread = interpolate(frame, [15, 45], [10, 45], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.4, 0, 0.2, 1),
  });

  // --- COUNTER-MOTION ---
  // Midground watermark moves opposite (to the left) at 20% speed
  const watermarkX = interpolate(frame, [0, 120], [20, -25]);

  // --- MICRO-CASCADE STAGGER (1/3 Element Rule, Budget < 300ms) ---
  // Item 1: Live Gold Rate ticker (Frames 28 - 48)
  const item1X = interpolate(frame, [28, 48], [30, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });
  const item1Opacity = interpolate(frame, [28, 44], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Item 2: Gross/Net Weight badge (Frames 40 - 60)
  const item2X = interpolate(frame, [40, 60], [30, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });
  const item2Opacity = interpolate(frame, [40, 56], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Item 3: Live Valuation Ticker (Frames 52 - 85)
  // Non-linear count up: Deceleration curve
  const countFactor = interpolate(frame, [52, 90], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });
  const liveValuation = Math.round(countFactor * 278500);

  // Shimmer gleam across card top border
  const gleamOffset = interpolate(frame, [35, 75], [-100, 200], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Exit transition
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

      {/* Counter-Motion Ambient Watermark */}
      <div
        style={{
          position: 'absolute',
          top: '32%',
          left: `calc(50% + ${watermarkX}px)`,
          transform: 'translateX(-50%)',
          fontSize: 160,
          fontWeight: 900,
          fontFamily: fonts.sans,
          color: 'rgba(212, 175, 55, 0.025)',
          whiteSpace: 'nowrap',
          letterSpacing: 20,
          pointerEvents: 'none',
          userSelect: 'none',
        }}
      >
        GIRVI SMART VALUATION
      </div>

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
            PILLAR II: VISUAL NARRATIVE & CHOREOGRAPHY
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
            1/3 RULE (DISTANCE &lt; 35px, STAGGER BUDGET: 280ms)
          </span>
        </div>
      </div>

      {/* HERO CARD (Primary Layer) */}
      <div
        style={{
          width: 900,
          backgroundColor: 'rgba(32, 20, 16, 0.92)',
          border: `1.5px solid ${colors.goldBorder}`,
          borderRadius: 20,
          padding: '36px 44px',
          boxShadow: `0 20px ${shadowSpread}px rgba(0, 0, 0, 0.75), 0 0 35px rgba(212, 175, 55, 0.12)`,
          transform: `translateY(${cardY}px)`,
          opacity: cardOpacity,
          position: 'relative',
          overflow: 'hidden',
          zIndex: 10,
        }}
      >
        {/* Shimmer Border Sweep */}
        <div
          style={{
            position: 'absolute',
            top: 0,
            left: `${gleamOffset}%`,
            width: 120,
            height: '100%',
            background:
              'linear-gradient(90deg, transparent 0%, rgba(255, 241, 197, 0.25) 50%, transparent 100%)',
            transform: 'skewX(-25deg)',
            pointerEvents: 'none',
          }}
        />

        {/* Card Header */}
        <div
          style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            borderBottom: '1px solid rgba(212, 175, 55, 0.2)',
            paddingBottom: 20,
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
            <div
              style={{
                width: 48,
                height: 48,
                borderRadius: 12,
                backgroundColor: 'rgba(212, 175, 55, 0.15)',
                border: `1px solid ${colors.goldBorder}`,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                <path
                  d="M12 2L2 7L12 12L22 7L12 2Z"
                  stroke={colors.champagneGold}
                  strokeWidth="2"
                  strokeLinecap="round"
                />
                <path
                  d="M2 17L12 22L22 17"
                  stroke={colors.champagneGold}
                  strokeWidth="2"
                  strokeLinecap="round"
                />
                <path
                  d="M2 12L12 17L22 12"
                  stroke={colors.champagneGold}
                  strokeWidth="2"
                  strokeLinecap="round"
                />
              </svg>
            </div>
            <div>
              <div
                style={{
                  fontFamily: fonts.serif,
                  fontSize: 22,
                  fontWeight: 700,
                  color: colors.cream,
                }}
              >
                Pledge Valuation #GL-9840
              </div>
              <div
                style={{
                  fontFamily: fonts.sans,
                  fontSize: 14,
                  color: colors.textSecondary,
                }}
              >
                Customer: Rajesh Verma · Bikaner Branch
              </div>
            </div>
          </div>

          <div
            style={{
              padding: '6px 14px',
              borderRadius: 20,
              backgroundColor: 'rgba(46, 204, 113, 0.15)',
              border: '1px solid rgba(46, 204, 113, 0.35)',
              color: colors.greenSuccess,
              fontFamily: fonts.mono,
              fontSize: 12,
              fontWeight: 700,
              letterSpacing: 1,
            }}
          >
            ● LIVE RATE VERIFIED
          </div>
        </div>

        {/* Micro-Cascade 1: Live Rate Ticker */}
        <div
          style={{
            marginTop: 24,
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            padding: '16px 20px',
            backgroundColor: 'rgba(17, 10, 8, 0.65)',
            borderRadius: 12,
            border: '1px solid rgba(255, 255, 255, 0.08)',
            transform: `translateX(${item1X}px)`,
            opacity: item1Opacity,
          }}
        >
          <span
            style={{
              fontFamily: fonts.sans,
              color: colors.creamMuted,
              fontSize: 15,
            }}
          >
            Today's 24K Gold Rate:
          </span>
          <span
            style={{
              fontFamily: fonts.mono,
              color: colors.champagneGold,
              fontSize: 18,
              fontWeight: 700,
            }}
          >
            ₹7,850.00 / gram
          </span>
        </div>

        {/* Micro-Cascade 2: Ornament Details */}
        <div
          style={{
            marginTop: 14,
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            padding: '16px 20px',
            backgroundColor: 'rgba(17, 10, 8, 0.65)',
            borderRadius: 12,
            border: '1px solid rgba(255, 255, 255, 0.08)',
            transform: `translateX(${item2X}px)`,
            opacity: item2Opacity,
          }}
        >
          <div>
            <div
              style={{
                fontFamily: fonts.sans,
                color: colors.cream,
                fontSize: 15,
                fontWeight: 600,
              }}
            >
              Gold Necklace (22K 916 Hallmark)
            </div>
            <div
              style={{
                fontFamily: fonts.mono,
                color: colors.textSecondary,
                fontSize: 13,
              }}
            >
              Gross: 42.500g · Stone: 3.850g · Net: 38.650g
            </div>
          </div>
          <div
            style={{
              fontFamily: fonts.mono,
              color: colors.burntAmber,
              fontSize: 15,
              fontWeight: 600,
            }}
          >
            LTV: 75%
          </div>
        </div>

        {/* Micro-Cascade 3: Live Valuation Output */}
        <div
          style={{
            marginTop: 22,
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            padding: '20px 24px',
            borderRadius: 14,
            background:
              'linear-gradient(135deg, rgba(212, 175, 55, 0.15) 0%, rgba(217, 103, 38, 0.1) 100%)',
            border: `1.5px solid ${colors.goldBorder}`,
          }}
        >
          <div>
            <div
              style={{
                fontFamily: fonts.sans,
                fontSize: 13,
                color: colors.champagneLight,
                letterSpacing: 2,
                textTransform: 'uppercase',
                fontWeight: 600,
              }}
            >
              Maximum Sanction Amount
            </div>
            <div
              style={{
                fontFamily: fonts.sans,
                fontSize: 12,
                color: colors.creamMuted,
              }}
            >
              Instant disbursement eligibility
            </div>
          </div>

          <div
            style={{
              fontFamily: fonts.mono,
              fontSize: 38,
              fontWeight: 800,
              color: colors.champagneLight,
              textShadow: '0 0 20px rgba(212, 175, 55, 0.4)',
            }}
          >
            ₹{liveValuation.toLocaleString('en-IN')}
          </div>
        </div>
      </div>
    </div>
  );
};