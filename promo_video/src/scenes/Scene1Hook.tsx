import React from 'react';
import { interpolate, spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { Background } from '../components/Background';
import { HeaderBadge } from '../components/HeaderBadge';
import { colors, fonts } from '../theme';

export const Scene1Hook: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // Entrance animations
  const titleEntrance = spring({
    frame: frame - 10,
    fps,
    config: { damping: 14, stiffness: 100 },
  });

  const cardsEntrance = spring({
    frame: frame - 25,
    fps,
    config: { damping: 16, stiffness: 90 },
  });

  // Fade out at end of scene
  const fadeOut = interpolate(frame, [100, 120], [1, 0], {
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
          textAlign: 'center',
        }}
      >
        <HeaderBadge category="Jewellery Pawn & Artisan Industry" badge="THE PROBLEM" />

        <h1
          style={{
            fontFamily: fonts.serif,
            fontSize: 66,
            fontWeight: 800,
            lineHeight: 1.25,
            color: colors.cream,
            maxWidth: 1350,
            margin: '0 0 24px 0',
            transform: `scale(${interpolate(titleEntrance, [0, 1], [0.92, 1])})`,
            opacity: interpolate(titleEntrance, [0, 1], [0, 1]),
            textShadow: '0 8px 30px rgba(0, 0, 0, 0.7)',
          }}
        >
          Still Running Your Pawn & Jewellery Business on{' '}
          <span
            style={{
              color: colors.burntAmber,
              textDecoration: 'underline',
              textDecorationColor: 'rgba(217, 103, 38, 0.5)',
            }}
          >
            Manual Paper Ledgers
          </span>
          ?
        </h1>

        <p
          style={{
            fontFamily: fonts.sans,
            fontSize: 26,
            color: colors.textSecondary,
            maxWidth: 960,
            lineHeight: 1.5,
            margin: '0 0 50px 0',
            opacity: interpolate(titleEntrance, [0, 1], [0, 1]),
          }}
        >
          Slow hand calculations. Disputed interest hisaab. Stolen or lost paper slips.
          And cloud software that locks your shop out the moment internet fails.
        </p>

        {/* 3 Pain Point Comparison Badges */}
        <div
          style={{
            display: 'flex',
            gap: 28,
            maxWidth: 1200,
            opacity: interpolate(cardsEntrance, [0, 1], [0, 1]),
            transform: `translateY(${interpolate(cardsEntrance, [0, 1], [40, 0])}px)`,
          }}
        >
          {[
            {
              icon: '⚠️',
              title: 'Manual Calculation Errors',
              desc: 'Purity variations, split month-day interest, and ghaat hisaab done on paper cost jewellers thousands monthly.',
            },
            {
              icon: '🔒',
              title: 'Cloud Dependency Lock-In',
              desc: 'Cloud ERPs hold your customer records hostage to annual subscription fees and fail when the wifi drops.',
            },
            {
              icon: '📄',
              title: 'Slip Disputes & Fraud',
              desc: 'Paper pawn slips without photos or barcodes lead to collateral disputes and verification delays.',
            },
          ].map((item, i) => (
            <div
              key={i}
              style={{
                flex: 1,
                padding: '30px 26px',
                borderRadius: 20,
                backgroundColor: 'rgba(30, 19, 16, 0.75)',
                border: '1px solid rgba(217, 103, 38, 0.25)',
                boxShadow: '0 12px 35px rgba(0, 0, 0, 0.5)',
                textAlign: 'left',
                position: 'relative',
              }}
            >
              <div style={{ fontSize: 36, marginBottom: 14 }}>{item.icon}</div>
              <h3
                style={{
                  fontFamily: fonts.sans,
                  fontSize: 22,
                  fontWeight: 700,
                  color: colors.cream,
                  marginBottom: 10,
                }}
              >
                {item.title}
              </h3>
              <p
                style={{
                  fontFamily: fonts.sans,
                  fontSize: 16,
                  color: colors.creamMuted,
                  lineHeight: 1.45,
                  margin: 0,
                }}
              >
                {item.desc}
              </p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
