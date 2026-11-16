import React from 'react';
import { interpolate, spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { Background } from '../components/Background';
import { HeaderBadge } from '../components/HeaderBadge';
import { colors, fonts } from '../theme';

export const Scene3RatesAndValuation: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // Entrance spring
  const contentEntrance = spring({
    frame: frame - 5,
    fps,
    config: { damping: 15, stiffness: 100 },
  });

  // Dynamic counter values
  const weight = interpolate(frame, [15, 60], [0, 18.5], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const netWeight = interpolate(frame, [25, 70], [0, 16.95], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const valuation = interpolate(frame, [35, 80], [0, 121870], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const principal = interpolate(frame, [45, 90], [0, 91400], {
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
        <HeaderBadge category="Daily Metal Rates & Precision Engines" badge="AUTOMATIC VALUATION" />

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
          Dynamic Daily Rates & Real-Time Gold Purity Resolver
        </h2>
        <p
          style={{
            fontFamily: fonts.sans,
            fontSize: 22,
            color: colors.textSecondary,
            margin: '0 0 36px 0',
            textAlign: 'center',
          }}
        >
          Updated daily rates drive instant net-weight calculations and 75% LTV sanction suggestions.
        </p>

        {/* Live Daily Rates Ribbon */}
        <div
          style={{
            display: 'flex',
            gap: 20,
            marginBottom: 32,
            width: 1100,
            transform: `scale(${interpolate(contentEntrance, [0, 1], [0.94, 1])})`,
            opacity: interpolate(contentEntrance, [0, 1], [0, 1]),
          }}
        >
          {[
            { metal: 'GOLD 24K (99.9%)', rate: '₹ 7,850 / g', change: '+₹40 today' },
            { metal: 'GOLD 22K (91.6% Hallmark)', rate: '₹ 7,190 / g', change: '+₹35 today' },
            { metal: 'SILVER 999', rate: '₹ 94.5 / g', change: '+₹0.8 today' },
          ].map((r, i) => (
            <div
              key={i}
              style={{
                flex: 1,
                padding: '16px 20px',
                borderRadius: 14,
                backgroundColor: 'rgba(35, 22, 19, 0.95)',
                border: `1px solid ${colors.goldBorder}`,
                display: 'flex',
                flexDirection: 'column',
                gap: 4,
                boxShadow: '0 8px 24px rgba(0, 0, 0, 0.4)',
              }}
            >
              <div
                style={{
                  fontFamily: fonts.mono,
                  fontSize: 12,
                  fontWeight: 700,
                  color: colors.creamMuted,
                  letterSpacing: 1,
                }}
              >
                {r.metal}
              </div>
              <div
                style={{
                  fontFamily: fonts.sans,
                  fontSize: 26,
                  fontWeight: 800,
                  color: colors.champagneLight,
                }}
              >
                {r.rate}
              </div>
              <div
                style={{
                  fontFamily: fonts.sans,
                  fontSize: 12,
                  fontWeight: 600,
                  color: colors.greenSuccess,
                }}
              >
                ▲ {r.change}
              </div>
            </div>
          ))}
        </div>

        {/* Interactive Calculation Card */}
        <div
          style={{
            width: 1100,
            padding: '34px 40px',
            borderRadius: 22,
            backgroundColor: colors.cardBg,
            border: `1.5px solid ${colors.goldBorder}`,
            boxShadow: `0 20px 60px rgba(0, 0, 0, 0.6), inset 0 0 30px rgba(212, 175, 55, 0.05)`,
            display: 'grid',
            gridTemplateColumns: 'repeat(4, 1fr)',
            gap: 24,
            transform: `translateY(${interpolate(contentEntrance, [0, 1], [30, 0])}px)`,
            opacity: interpolate(contentEntrance, [0, 1], [0, 1]),
          }}
        >
          <div>
            <div
              style={{
                fontFamily: fonts.sans,
                fontSize: 14,
                color: colors.creamMuted,
                marginBottom: 8,
              }}
            >
              Gross Ornament Weight
            </div>
            <div
              style={{
                fontFamily: fonts.mono,
                fontSize: 34,
                fontWeight: 800,
                color: colors.cream,
              }}
            >
              {weight.toFixed(2)}{' '}
              <span style={{ fontSize: 18, color: colors.creamMuted }}>g</span>
            </div>
            <div style={{ fontSize: 13, color: colors.textSecondary, marginTop: 4 }}>
              Ornament: Gold Bangle (22K)
            </div>
          </div>

          <div>
            <div
              style={{
                fontFamily: fonts.sans,
                fontSize: 14,
                color: colors.creamMuted,
                marginBottom: 8,
              }}
            >
              Hallmark Net Pure Metal
            </div>
            <div
              style={{
                fontFamily: fonts.mono,
                fontSize: 34,
                fontWeight: 800,
                color: colors.champagneLight,
              }}
            >
              {netWeight.toFixed(2)}{' '}
              <span style={{ fontSize: 18, color: colors.creamMuted }}>g</span>
            </div>
            <div style={{ fontSize: 13, color: colors.champagneDark, marginTop: 4 }}>
              Resolved @ 91.60% purity
            </div>
          </div>

          <div>
            <div
              style={{
                fontFamily: fonts.sans,
                fontSize: 14,
                color: colors.creamMuted,
                marginBottom: 8,
              }}
            >
              Estimated Vault Valuation
            </div>
            <div
              style={{
                fontFamily: fonts.mono,
                fontSize: 34,
                fontWeight: 800,
                color: colors.cream,
              }}
            >
              ₹ {Math.round(valuation).toLocaleString('en-IN')}
            </div>
            <div style={{ fontSize: 13, color: colors.greenSuccess, marginTop: 4 }}>
              Live market collateral value
            </div>
          </div>

          <div
            style={{
              backgroundColor: 'rgba(217, 103, 38, 0.15)',
              padding: '12px 18px',
              borderRadius: 14,
              border: '1px solid rgba(217, 103, 38, 0.4)',
            }}
          >
            <div
              style={{
                fontFamily: fonts.sans,
                fontSize: 13,
                fontWeight: 700,
                color: colors.burntAmber,
                marginBottom: 6,
                textTransform: 'uppercase',
                letterSpacing: 0.5,
              }}
            >
              Suggested Sanction (75%)
            </div>
            <div
              style={{
                fontFamily: fonts.mono,
                fontSize: 34,
                fontWeight: 900,
                color: colors.burntAmber,
              }}
            >
              ₹ {Math.round(principal).toLocaleString('en-IN')}
            </div>
            <div style={{ fontSize: 12, color: colors.cream, marginTop: 4 }}>
              ROI: 1.50% / month (DayWise/MonthWise)
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
