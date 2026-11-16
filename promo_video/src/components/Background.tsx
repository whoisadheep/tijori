import React from 'react';
import { interpolate, useCurrentFrame } from 'remotion';
import { colors } from '../theme';

export const Background: React.FC<{ accentColor?: string }> = ({
  accentColor = colors.champagneGold,
}) => {
  const frame = useCurrentFrame();

  // Subtle floating light pulse
  const pulse = interpolate(Math.sin(frame / 25), [-1, 1], [0.15, 0.28]);
  const secondaryPulse = interpolate(Math.cos(frame / 35), [-1, 1], [0.08, 0.18]);

  return (
    <div
      style={{
        position: 'absolute',
        width: 1920,
        height: 1080,
        backgroundColor: colors.deepVault,
        backgroundImage: `
          radial-gradient(circle at 50% 20%, rgba(212, 175, 55, ${pulse}) 0%, transparent 55%),
          radial-gradient(circle at 85% 75%, rgba(217, 103, 38, ${secondaryPulse}) 0%, transparent 45%),
          radial-gradient(circle at 15% 80%, rgba(67, 44, 38, 0.5) 0%, transparent 50%),
          linear-gradient(180deg, #180F0D 0%, #0E0705 100%)
        `,
        overflow: 'hidden',
      }}
    >
      {/* Luxury subtle geometric grid overlay */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          backgroundImage: `
            linear-gradient(to right, rgba(212, 175, 55, 0.04) 1px, transparent 1px),
            linear-gradient(to bottom, rgba(212, 175, 55, 0.04) 1px, transparent 1px)
          `,
          backgroundSize: '80px 80px',
          opacity: 0.7,
        }}
      />

      {/* Floating subtle gold particle orbs */}
      {[...Array(12)].map((_, i) => {
        const x = (i * 163 + 80) % 1840;
        const initialY = (i * 241 + 100) % 1000;
        const speed = 0.5 + (i % 4) * 0.3;
        const y = (initialY - frame * speed + 1200) % 1200 - 100;
        const size = 3 + (i % 3) * 2;
        const opacity = interpolate(
          Math.sin((frame + i * 20) / 30),
          [-1, 1],
          [0.2, 0.65]
        );

        return (
          <div
            key={i}
            style={{
              position: 'absolute',
              left: x,
              top: y,
              width: size,
              height: size,
              borderRadius: '50%',
              backgroundColor: colors.champagneLight,
              boxShadow: `0 0 10px 2px ${colors.champagneGold}`,
              opacity,
            }}
          />
        );
      })}
    </div>
  );
};
