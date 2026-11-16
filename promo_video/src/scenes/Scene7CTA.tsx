import React from 'react';
import { interpolate, spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { Background } from '../components/Background';
import { colors, fonts } from '../theme';

export const Scene7CTA: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // Entrance springs
  const logoScale = spring({
    frame: frame - 4,
    fps,
    config: { damping: 13, stiffness: 105 },
  });

  const textEntrance = spring({
    frame: frame - 16,
    fps,
    config: { damping: 15, stiffness: 90 },
  });

  const ctaPulse = interpolate(Math.sin(frame / 12), [-1, 1], [1, 1.04]);

  return (
    <div
      style={{
        position: 'relative',
        width: 1920,
        height: 1080,
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
        {/* Emblem */}
        <div
          style={{
            width: 100,
            height: 100,
            borderRadius: 26,
            backgroundColor: 'rgba(67, 44, 38, 0.95)',
            border: `2px solid ${colors.champagneGold}`,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            boxShadow: `0 0 50px rgba(212, 175, 55, 0.45)`,
            transform: `scale(${interpolate(logoScale, [0, 1], [0.7, 1])})`,
            opacity: interpolate(logoScale, [0, 1], [0, 1]),
            marginBottom: 20,
          }}
        >
          <svg
            width="52"
            height="52"
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

        <h1
          style={{
            fontFamily: fonts.serif,
            fontSize: 90,
            fontWeight: 900,
            letterSpacing: 10,
            color: colors.champagneLight,
            margin: '0 0 12px 0',
            textShadow: '0 10px 40px rgba(212, 175, 55, 0.3)',
            opacity: interpolate(textEntrance, [0, 1], [0, 1]),
          }}
        >
          TIJORI
        </h1>

        <p
          style={{
            fontFamily: fonts.serif,
            fontSize: 36,
            fontWeight: 700,
            color: colors.cream,
            maxWidth: 1000,
            margin: '0 0 16px 0',
            opacity: interpolate(textEntrance, [0, 1], [0, 1]),
          }}
        >
          Your Vault. Your Data. Your Terms.
        </p>

        <p
          style={{
            fontFamily: fonts.sans,
            fontSize: 22,
            color: colors.creamMuted,
            maxWidth: 850,
            lineHeight: 1.5,
            margin: '0 0 44px 0',
            opacity: interpolate(textEntrance, [0, 1], [0, 1]),
          }}
        >
          The production-grade, offline-first jewellery pawn & artisan management ERP.
          No cloud fees, no internet outages, and 100% financial privacy.
        </p>

        {/* Big Call to Action Button */}
        <div
          style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: 16,
            padding: '22px 54px',
            borderRadius: 50,
            backgroundColor: colors.champagneGold,
            color: colors.deepVault,
            fontFamily: fonts.sans,
            fontSize: 24,
            fontWeight: 800,
            letterSpacing: 1,
            boxShadow: `0 12px 40px rgba(212, 175, 55, 0.5), 0 0 25px rgba(212, 175, 55, 0.3)`,
            transform: `scale(${ctaPulse})`,
            opacity: interpolate(textEntrance, [0, 1], [0, 1]),
          }}
        >
          <span>Get Started with Tijori ERP</span>
          <span>→</span>
        </div>

        {/* Footer Subtext */}
        <div
          style={{
            fontFamily: fonts.mono,
            fontSize: 14,
            color: colors.textSecondary,
            marginTop: 36,
            letterSpacing: 1,
            opacity: interpolate(textEntrance, [0, 1], [0, 1]),
          }}
        >
          DESKTOP (LINUX & WINDOWS) • ESC/POS THERMAL PRINTING • LOCAL SQLITE WAL
        </div>
      </div>
    </div>
  );
};
