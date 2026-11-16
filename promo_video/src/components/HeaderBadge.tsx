import React from 'react';
import { interpolate, spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { colors, fonts } from '../theme';

export const HeaderBadge: React.FC<{
  category: string;
  badge?: string;
}> = ({ category, badge = 'OFFLINE ERP' }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const entrance = spring({
    frame,
    fps,
    config: { damping: 15, stiffness: 120 },
  });

  const opacity = interpolate(entrance, [0, 1], [0, 1]);
  const translateY = interpolate(entrance, [0, 1], [-20, 0]);

  return (
    <div
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: 12,
        padding: '8px 20px',
        borderRadius: 30,
        backgroundColor: 'rgba(45, 29, 24, 0.8)',
        border: `1px solid ${colors.goldBorder}`,
        boxShadow: `0 8px 24px rgba(0, 0, 0, 0.4), 0 0 15px ${colors.goldGlow}`,
        opacity,
        transform: `translateY(${translateY}px)`,
        marginBottom: 20,
      }}
    >
      <div
        style={{
          width: 8,
          height: 8,
          borderRadius: '50%',
          backgroundColor: colors.burntAmber,
          boxShadow: `0 0 8px ${colors.burntAmber}`,
        }}
      />
      <span
        style={{
          fontFamily: fonts.sans,
          fontSize: 15,
          fontWeight: 700,
          letterSpacing: 2,
          color: colors.champagneLight,
          textTransform: 'uppercase',
        }}
      >
        {category}
      </span>
      <span
        style={{
          padding: '2px 8px',
          borderRadius: 6,
          backgroundColor: 'rgba(217, 103, 38, 0.25)',
          border: '1px solid rgba(217, 103, 38, 0.5)',
          fontFamily: fonts.mono,
          fontSize: 12,
          fontWeight: 700,
          color: colors.burntAmber,
          letterSpacing: 1,
        }}
      >
        {badge}
      </span>
    </div>
  );
};
