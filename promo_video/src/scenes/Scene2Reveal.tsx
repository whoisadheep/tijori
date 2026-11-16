import React from 'react';
import { interpolate, spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { Background } from '../components/Background';
import { colors, fonts } from '../theme';

export const Scene2Reveal: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // Entrance spring
  const logoScale = spring({
    frame: frame - 5,
    fps,
    config: { damping: 12, stiffness: 110 },
  });

  const textEntrance = spring({
    frame: frame - 18,
    fps,
    config: { damping: 15, stiffness: 90 },
  });

  const badgeEntrance = spring({
    frame: frame - 32,
    fps,
    config: { damping: 14, stiffness: 100 },
  });

  // Gold shimmer sweep
  const shimmerPos = interpolate(frame, [20, 90], [-100, 200], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Fade out
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
        {/* Vault Crest Logo */}
        <div
          style={{
            width: 120,
            height: 120,
            borderRadius: 30,
            backgroundColor: 'rgba(67, 44, 38, 0.9)',
            border: `2px solid ${colors.champagneGold}`,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            boxShadow: `0 0 50px rgba(212, 175, 55, 0.4), inset 0 0 25px rgba(212, 175, 55, 0.2)`,
            transform: `scale(${interpolate(logoScale, [0, 1], [0.6, 1])}) rotate(${interpolate(
              logoScale,
              [0, 1],
              [-15, 0]
            )}deg)`,
            opacity: interpolate(logoScale, [0, 1], [0, 1]),
            marginBottom: 28,
          }}
        >
          <svg
            width="64"
            height="64"
            viewBox="0 0 24 24"
            fill="none"
            stroke={colors.champagneLight}
            strokeWidth="1.8"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
            <path d="M7 11V7a5 5 0 0 1 10 0v4" />
            <circle cx="12" cy="16" r="1.5" fill={colors.champagneLight} />
          </svg>
        </div>

        {/* Small Intro Badge */}
        <div
          style={{
            fontSize: 16,
            fontWeight: 800,
            letterSpacing: 6,
            color: colors.burntAmber,
            textTransform: 'uppercase',
            marginBottom: 14,
            opacity: interpolate(textEntrance, [0, 1], [0, 1]),
          }}
        >
          INTRODUCING
        </div>

        {/* TIJORI Title with shimmering gold effect */}
        <h1
          style={{
            fontFamily: fonts.serif,
            fontSize: 110,
            fontWeight: 900,
            letterSpacing: 14,
            margin: '0 0 16px 0',
            background: `linear-gradient(90deg, #D4AF37 0%, #FFF1C5 ${shimmerPos}%, #D4AF37 100%)`,
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            textShadow: '0 10px 40px rgba(212, 175, 55, 0.25)',
            transform: `scale(${interpolate(textEntrance, [0, 1], [0.94, 1])})`,
            opacity: interpolate(textEntrance, [0, 1], [0, 1]),
          }}
        >
          TIJORI
        </h1>

        <p
          style={{
            fontFamily: fonts.sans,
            fontSize: 32,
            fontWeight: 500,
            color: colors.cream,
            maxWidth: 1000,
            lineHeight: 1.4,
            margin: '0 0 44px 0',
            opacity: interpolate(textEntrance, [0, 1], [0, 1]),
          }}
        >
          The Offline Vault ERP for Jewellers, Pawnbrokers & Artisans
        </p>

        {/* 4 Core Pillars */}
        <div
          style={{
            display: 'flex',
            gap: 20,
            opacity: interpolate(badgeEntrance, [0, 1], [0, 1]),
            transform: `translateY(${interpolate(badgeEntrance, [0, 1], [30, 0])}px)`,
          }}
        >
          {[
            { title: '100% Offline-First', sub: 'Zero Cloud Dependency' },
            { title: 'Local SQLite Vault', sub: 'Encrypted & Fast' },
            { title: 'Milligram Precision', sub: 'Purity & Hisaab' },
            { title: 'Thermal & A4 Slips', sub: 'Photos & Barcodes' },
          ].map((pill, i) => (
            <div
              key={i}
              style={{
                padding: '16px 28px',
                borderRadius: 16,
                backgroundColor: 'rgba(45, 29, 24, 0.9)',
                border: `1.5px solid ${colors.goldBorder}`,
                boxShadow: `0 8px 24px rgba(0, 0, 0, 0.4), inset 0 0 15px rgba(212, 175, 55, 0.08)`,
              }}
            >
              <div
                style={{
                  fontFamily: fonts.sans,
                  fontSize: 18,
                  fontWeight: 700,
                  color: colors.champagneLight,
                  marginBottom: 4,
                }}
              >
                {pill.title}
              </div>
              <div
                style={{
                  fontFamily: fonts.mono,
                  fontSize: 13,
                  color: colors.creamMuted,
                  letterSpacing: 0.5,
                }}
              >
                {pill.sub}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
