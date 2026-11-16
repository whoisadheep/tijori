import React from 'react';
import { interpolate, spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { Background } from '../components/Background';
import { HeaderBadge } from '../components/HeaderBadge';
import { colors, fonts } from '../theme';

export const Scene6GSTAndCash: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // Entrance spring
  const contentEntrance = spring({
    frame: frame - 4,
    fps,
    config: { damping: 15, stiffness: 100 },
  });

  // Fade out
  const fadeOut = interpolate(frame, [75, 90], [1, 0], {
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
        <HeaderBadge category="Financial Accuracy & Audit" badge="GST & CASH DRAWER" />

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
          GST Invoicing & Daily Cash Drawer (Rojnamcha)
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
          Generate HSN-compliant tax invoices and reconcile your counter cash drawer at closing time.
        </p>

        {/* Dual Cards */}
        <div
          style={{
            display: 'flex',
            gap: 28,
            width: 1100,
            transform: `translateY(${interpolate(contentEntrance, [0, 1], [30, 0])}px)`,
            opacity: interpolate(contentEntrance, [0, 1], [0, 1]),
          }}
        >
          {/* GST Invoicing Card */}
          <div
            style={{
              flex: 1,
              padding: '30px',
              borderRadius: 20,
              backgroundColor: colors.cardBg,
              border: `1.5px solid ${colors.goldBorder}`,
              boxShadow: '0 16px 45px rgba(0, 0, 0, 0.5)',
            }}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 16 }}>
              <span style={{ fontFamily: fonts.mono, fontSize: 13, color: colors.champagneLight, fontWeight: 700 }}>
                GST TAX INVOICE #TIJ-26-081
              </span>
              <span style={{ fontSize: 12, color: colors.greenSuccess, fontWeight: 700 }}>
                HSN 7113 COMPLIANT
              </span>
            </div>

            <div style={{ fontSize: 18, fontWeight: 700, color: colors.cream, marginBottom: 14 }}>
              Gold Chain & Diamond Pendant (22K)
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 8, fontSize: 14 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', color: colors.creamMuted }}>
                <span>Taxable Value:</span>
                <span>₹ 1,00,000.00</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', color: colors.creamMuted }}>
                <span>CGST (1.50%):</span>
                <span>₹ 1,500.00</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', color: colors.creamMuted }}>
                <span>SGST (1.50%):</span>
                <span>₹ 1,500.00</span>
              </div>
              <div
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  borderTop: `1px solid ${colors.goldBorder}`,
                  paddingTop: 8,
                  fontSize: 18,
                  fontWeight: 800,
                  color: colors.champagneLight,
                }}
              >
                <span>Total Invoice:</span>
                <span>₹ 1,03,000.00</span>
              </div>
            </div>
          </div>

          {/* Rojnamcha Cash Register Card */}
          <div
            style={{
              flex: 1,
              padding: '30px',
              borderRadius: 20,
              backgroundColor: colors.cardBg,
              border: `1.5px solid rgba(217, 103, 38, 0.4)`,
              boxShadow: '0 16px 45px rgba(0, 0, 0, 0.5)',
            }}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 16 }}>
              <span style={{ fontFamily: fonts.mono, fontSize: 13, color: colors.burntAmber, fontWeight: 700 }}>
                DAILY CASH DRAWER (ROJNAMCHA)
              </span>
              <span style={{ fontSize: 12, color: colors.burntAmber, fontWeight: 700 }}>
                TILL #1 RECONCILED
              </span>
            </div>

            <div style={{ fontSize: 18, fontWeight: 700, color: colors.cream, marginBottom: 14 }}>
              Counter Cash Balance Summary
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: 8, fontSize: 14 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', color: colors.creamMuted }}>
                <span>Opening Cash Drawer:</span>
                <span>₹ 45,000.00</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', color: colors.greenSuccess }}>
                <span>Total Cash Inflows (Receipts):</span>
                <span>+ ₹ 1,84,500.00</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', color: colors.burntAmber }}>
                <span>Total Disbursements & Expenses:</span>
                <span>- ₹ 92,000.00</span>
              </div>
              <div
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  borderTop: '1px solid rgba(217, 103, 38, 0.4)',
                  paddingTop: 8,
                  fontSize: 18,
                  fontWeight: 800,
                  color: colors.cream,
                }}
              >
                <span>Closing Drawer Cash:</span>
                <span style={{ color: colors.burntAmber }}>₹ 1,37,500.00</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
