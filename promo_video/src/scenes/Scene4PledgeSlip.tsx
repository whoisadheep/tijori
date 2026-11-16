import React from 'react';
import { interpolate, spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { Background } from '../components/Background';
import { HeaderBadge } from '../components/HeaderBadge';
import { colors, fonts } from '../theme';

export const Scene4PledgeSlip: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // Slip slide down animation (as if printing from a thermal POS printer!)
  const printSlide = spring({
    frame: frame - 8,
    fps,
    config: { damping: 15, stiffness: 85 },
  });

  const badgeEntrance = spring({
    frame: frame - 25,
    fps,
    config: { damping: 14, stiffness: 100 },
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
          alignItems: 'center',
          justifyContent: 'space-between',
          padding: '60px 140px',
        }}
      >
        {/* Left Side: Key Feature Bullet Points */}
        <div style={{ maxWidth: 760 }}>
          <HeaderBadge category="Collateral Security & Documentation" badge="SLIP GENERATION" />

          <h2
            style={{
              fontFamily: fonts.serif,
              fontSize: 54,
              fontWeight: 800,
              color: colors.cream,
              margin: '0 0 16px 0',
              lineHeight: 1.25,
            }}
          >
            Instant Thermal & A4 Slips with Embedded Collateral Photos
          </h2>

          <p
            style={{
              fontFamily: fonts.sans,
              fontSize: 22,
              color: colors.textSecondary,
              lineHeight: 1.5,
              margin: '0 0 36px 0',
            }}
          >
            Sanction loans in seconds. Print legally binding, tamper-resistant pledge slips with
            ornament photos, Code-128 barcodes, and exact interest terms.
          </p>

          <div
            style={{
              display: 'flex',
              flexDirection: 'column',
              gap: 16,
              opacity: interpolate(badgeEntrance, [0, 1], [0, 1]),
              transform: `translateX(${interpolate(badgeEntrance, [0, 1], [-20, 0])}px)`,
            }}
          >
            {[
              {
                title: 'High-Speed 80mm Thermal Printing',
                desc: 'Print customer and shop copies on standard ESC/POS receipt printers in under 2 seconds.',
              },
              {
                title: 'Offline Vault Photo Storage',
                desc: 'Ornament & KYC photos stored locally on disk — no cloud upload required.',
              },
              {
                title: 'Barcode & QR Code Quick Lookup',
                desc: 'Scan barcode on release to pull up customer ledger and compute interest automatically.',
              },
            ].map((feature, i) => (
              <div
                key={i}
                style={{
                  display: 'flex',
                  alignItems: 'flex-start',
                  gap: 16,
                  padding: '16px 20px',
                  borderRadius: 14,
                  backgroundColor: 'rgba(38, 24, 20, 0.7)',
                  border: '1px solid rgba(212, 175, 55, 0.2)',
                }}
              >
                <div
                  style={{
                    width: 28,
                    height: 28,
                    borderRadius: '50%',
                    backgroundColor: 'rgba(46, 204, 113, 0.2)',
                    border: '1.5px solid #2ECC71',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    color: '#2ECC71',
                    fontSize: 16,
                    flexShrink: 0,
                    marginTop: 2,
                  }}
                >
                  ✓
                </div>
                <div>
                  <div
                    style={{
                      fontFamily: fonts.sans,
                      fontSize: 18,
                      fontWeight: 700,
                      color: colors.champagneLight,
                      marginBottom: 2,
                    }}
                  >
                    {feature.title}
                  </div>
                  <div
                    style={{
                      fontFamily: fonts.sans,
                      fontSize: 14,
                      color: colors.creamMuted,
                      lineHeight: 1.4,
                    }}
                  >
                    {feature.desc}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Right Side: Realistic Thermal Slip Mockup */}
        <div
          style={{
            width: 440,
            transform: `translateY(${interpolate(printSlide, [0, 1], [-120, 0])}px)`,
            opacity: interpolate(printSlide, [0, 1], [0, 1]),
          }}
        >
          {/* Printer Output Slot Mockup */}
          <div
            style={{
              width: '100%',
              height: 16,
              borderRadius: '8px 8px 0 0',
              backgroundColor: '#1C120F',
              border: '2px solid rgba(212, 175, 55, 0.4)',
              borderBottom: 'none',
              boxShadow: '0 -10px 30px rgba(0, 0, 0, 0.8)',
            }}
          />

          {/* Thermal Paper Receipt */}
          <div
            style={{
              backgroundColor: '#FCFAF4',
              color: '#1A1A1A',
              padding: '28px 24px',
              fontFamily: fonts.mono,
              borderRadius: '0 0 4px 4px',
              boxShadow: '0 25px 60px rgba(0, 0, 0, 0.8), 0 0 35px rgba(212, 175, 55, 0.15)',
              position: 'relative',
              fontSize: 13,
              lineHeight: 1.4,
            }}
          >
            {/* Shop Header */}
            <div style={{ textAlign: 'center', marginBottom: 16, borderBottom: '1px dashed #777', paddingBottom: 12 }}>
              <div style={{ fontFamily: fonts.serif, fontSize: 20, fontWeight: 800, letterSpacing: 1 }}>
                TIJORI JEWELLERS & VAULT
              </div>
              <div style={{ fontSize: 11, color: '#555' }}>
                Main Market, Zaveri Bazaar • Ph: +91 98200 12345
              </div>
              <div style={{ fontSize: 13, fontWeight: 700, marginTop: 6, letterSpacing: 1 }}>
                PAWN PLEDGE SLIP (GIRVI)
              </div>
              <div style={{ fontSize: 14, fontWeight: 800, color: colors.mochaBrown }}>
                # GIRVI-000042
              </div>
            </div>

            {/* Borrower Info */}
            <div style={{ marginBottom: 12, borderBottom: '1px dashed #999', paddingBottom: 8 }}>
              <div><strong>Customer:</strong> Rohan Sharma</div>
              <div><strong>Mobile:</strong> +91 98765 43210</div>
              <div><strong>Date:</strong> 29/10/2026 • <strong>ROI:</strong> 1.50% / mo</div>
            </div>

            {/* Pledged Item & Photo Simulation */}
            <div style={{ display: 'flex', gap: 12, marginBottom: 14, alignItems: 'center' }}>
              <div
                style={{
                  width: 70,
                  height: 70,
                  borderRadius: 6,
                  backgroundColor: '#EAD7BD',
                  border: '1.5px solid #8C6A43',
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontSize: 10,
                  fontWeight: 700,
                  color: '#432C26',
                  textAlign: 'center',
                  padding: 4,
                }}
              >
                <span>📷</span>
                <span>PHOTO</span>
                <span>ATTACHED</span>
              </div>
              <div>
                <div style={{ fontWeight: 800 }}>Gold Bangle (22K Hallmark)</div>
                <div>Gross Wt: <strong>18.50 g</strong></div>
                <div>Net Pure: <strong>16.95 g</strong> (91.6%)</div>
                <div>Vault: <strong>Vault 1 / Box A-12</strong></div>
              </div>
            </div>

            {/* Financials Box */}
            <div
              style={{
                backgroundColor: '#EDE6D6',
                padding: '10px 14px',
                borderRadius: 6,
                marginBottom: 14,
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <span>Valuation:</span>
                <strong>₹ 1,21,870</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 16, fontWeight: 900, color: colors.mochaBrown, marginTop: 4 }}>
                <span>Sanctioned:</span>
                <span>₹ 91,400</span>
              </div>
            </div>

            {/* Barcode Simulation */}
            <div style={{ textAlign: 'center', marginTop: 10 }}>
              <div
                style={{
                  height: 36,
                  backgroundImage:
                    'repeating-linear-gradient(90deg, #1A1A1A 0px, #1A1A1A 2px, transparent 2px, transparent 5px, #1A1A1A 5px, #1A1A1A 8px, transparent 8px, transparent 10px)',
                  marginBottom: 4,
                }}
              />
              <div style={{ fontSize: 10, letterSpacing: 4 }}>*GIRVI-000042*</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
