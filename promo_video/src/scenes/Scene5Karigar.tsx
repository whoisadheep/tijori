import React from 'react';
import { interpolate, spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { Background } from '../components/Background';
import { HeaderBadge } from '../components/HeaderBadge';
import { colors, fonts } from '../theme';

export const Scene5Karigar: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // Entrance spring
  const contentEntrance = spring({
    frame: frame - 5,
    fps,
    config: { damping: 14, stiffness: 95 },
  });

  // Animated balances
  const issued = interpolate(frame, [15, 55], [0, 50.0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const received = interpolate(frame, [30, 75], [0, 48.2], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const wastage = interpolate(frame, [45, 90], [0, 1.8], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Fade out
  const fadeOut = interpolate(frame, [130, 150], [1, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  return (
    <div
      style={{
        position: 'relative',
        width: 1920,
        height: 1080,
        opacity: fadeOut,
      }}
    >
      <Background />

      <div
        style={{
          position: 'absolute',
          inset: 0,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          padding: '60px 100px',
        }}
      >
        <HeaderBadge category="Artisan & Workshop Management" badge="KARIGAR HISAAB" />

        <h2
          style={{
            fontFamily: fonts.serif,
            fontSize: 52,
            fontWeight: 800,
            color: colors.cream,
            margin: '0 0 12px 0',
            textAlign: 'center',
          }}
        >
          Karigar Metal Ledger: Prevent Metal Leakage
        </h2>

        <p
          style={{
            fontFamily: fonts.sans,
            fontSize: 22,
            color: colors.textSecondary,
            margin: '0 0 36px 0',
            textAlign: 'center',
            maxWidth: 1000,
          }}
        >
          Track raw metal issued, finished ornaments received, and allowable wastage (ghaat)
          with exact milligram pure gold conversion.
        </p>

        {/* Karigar Hisaab Dashboard Mockup */}
        <div
          style={{
            width: 1140,
            padding: '36px 44px',
            borderRadius: 22,
            backgroundColor: colors.cardBg,
            border: `1.5px solid ${colors.goldBorder}`,
            boxShadow: `0 20px 60px rgba(0, 0, 0, 0.6)`,
            transform: `translateY(${interpolate(contentEntrance, [0, 1], [30, 0])}px)`,
            opacity: interpolate(contentEntrance, [0, 1], [0, 1]),
          }}
        >
          {/* Artisan Header Bar */}
          <div
            style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              borderBottom: `1px solid ${colors.goldBorder}`,
              paddingBottom: 20,
              marginBottom: 24,
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
              <div
                style={{
                  width: 52,
                  height: 52,
                  borderRadius: 14,
                  backgroundColor: 'rgba(212, 175, 55, 0.2)',
                  border: `1.5px solid ${colors.champagneGold}`,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontSize: 24,
                }}
              >
                ⚒️
              </div>
              <div>
                <div style={{ fontFamily: fonts.serif, fontSize: 24, fontWeight: 800, color: colors.cream }}>
                  Gopal Goldsmith (Artisan #12)
                </div>
                <div style={{ fontFamily: fonts.mono, fontSize: 13, color: colors.creamMuted }}>
                  Workshop Ledger: Kolkata Karigar Line • Active Order: #ORD-9821
                </div>
              </div>
            </div>

            <div
              style={{
                padding: '8px 16px',
                borderRadius: 10,
                backgroundColor: 'rgba(46, 204, 113, 0.15)',
                border: '1px solid #2ECC71',
                color: '#2ECC71',
                fontFamily: fonts.mono,
                fontWeight: 700,
                fontSize: 14,
              }}
            >
              ● PURE METAL BALANCED (0.000 g)
            </div>
          </div>

          {/* 3 Step Flow */}
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 24 }}>
            {/* 1. Issue */}
            <div
              style={{
                padding: '24px',
                borderRadius: 16,
                backgroundColor: 'rgba(217, 103, 38, 0.12)',
                border: '1px solid rgba(217, 103, 38, 0.35)',
              }}
            >
              <div style={{ fontFamily: fonts.mono, fontSize: 13, color: colors.burntAmber, fontWeight: 700 }}>
                1. METAL ISSUED
              </div>
              <div style={{ fontFamily: fonts.mono, fontSize: 36, fontWeight: 800, color: colors.cream, margin: '10px 0' }}>
                {issued.toFixed(3)} <span style={{ fontSize: 18, color: colors.creamMuted }}>g</span>
              </div>
              <div style={{ fontSize: 13, color: colors.creamMuted }}>
                Raw 24K Gold Bar (99.90%)
              </div>
            </div>

            {/* 2. Received */}
            <div
              style={{
                padding: '24px',
                borderRadius: 16,
                backgroundColor: 'rgba(212, 175, 55, 0.12)',
                border: `1px solid ${colors.goldBorder}`,
              }}
            >
              <div style={{ fontFamily: fonts.mono, fontSize: 13, color: colors.champagneLight, fontWeight: 700 }}>
                2. ORNAMENTS RECEIVED
              </div>
              <div style={{ fontFamily: fonts.mono, fontSize: 36, fontWeight: 800, color: colors.champagneLight, margin: '10px 0' }}>
                {received.toFixed(3)} <span style={{ fontSize: 18, color: colors.creamMuted }}>g</span>
              </div>
              <div style={{ fontSize: 13, color: colors.creamMuted }}>
                4x 22K Finished Bangles (91.60%)
              </div>
            </div>

            {/* 3. Allowable Ghaat / Wastage */}
            <div
              style={{
                padding: '24px',
                borderRadius: 16,
                backgroundColor: 'rgba(46, 204, 113, 0.1)',
                border: '1px solid rgba(46, 204, 113, 0.3)',
              }}
            >
              <div style={{ fontFamily: fonts.mono, fontSize: 13, color: '#2ECC71', fontWeight: 700 }}>
                3. GHAAT (WASTAGE) SETTLED
              </div>
              <div style={{ fontFamily: fonts.mono, fontSize: 36, fontWeight: 800, color: '#2ECC71', margin: '10px 0' }}>
                {wastage.toFixed(3)} <span style={{ fontSize: 18, color: colors.creamMuted }}>g</span>
              </div>
              <div style={{ fontSize: 13, color: colors.creamMuted }}>
                Allowable Polish & Filing Wastage (3.60%)
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
