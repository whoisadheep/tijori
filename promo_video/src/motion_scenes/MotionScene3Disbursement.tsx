import React from 'react';
import { interpolate, useCurrentFrame, Easing } from 'remotion';
import { colors, fonts } from '../theme';
import { Background } from '../components/Background';

/**
 * Scene 3: Disney Principles & Tactile State Transition
 * Motion Principles Applied:
 * - Anticipation: CTA button compresses to 0.96 before triggering
 * - Squash & Stretch: Button micro-squashes (scaleX 1.04, scaleY 0.96)
 * - State Change: Pop overshoot with ease-out-back (settles to 1.0)
 * - SVG Checkmark draw: strokeDashoffset 100% -> 0%
 * - Material-Based Easing: Paper slip ejection (duration 1.0x, subtle 3% settle)
 * - Impact Stamp: 1.15x -> 1.0x rigid stop
 */
export const MotionScene3Disbursement: React.FC = () => {
  const frame = useCurrentFrame();

  // --- BUTTON MICRO-INTERACTION (Frames 10 to 45) ---
  // 1. Anticipation (Frames 12 to 20): Button scales down to 0.96
  const anticipationScale = interpolate(frame, [12, 20], [1, 0.96], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  // 2. Squash (Frames 20 to 26): micro-squash [1.04, 0.96]
  const squashX = interpolate(frame, [20, 26], [1, 1.04], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });
  const squashY = interpolate(frame, [20, 26], [1, 0.96], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // 3. Release & Settle (Frames 26 to 45): Overshoot & settle back to 1.0
  const settleScale = interpolate(frame, [26, 42], [0.96, 1.0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.back(1.5)),
  });

  const btnScale =
    frame < 20 ? anticipationScale : frame < 26 ? 1.0 : settleScale;

  // Button Color & State Morph (Frames 24 to 35)
  const isApproved = frame >= 24;

  // --- SUCCESS BADGE & CHECKMARK DRAW (Frames 26 to 50) ---
  const badgePopScale = interpolate(frame, [24, 38], [0.6, 1.0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.back(1.8)),
  });

  // Checkmark stroke dashoffset (100 -> 0)
  const checkmarkProgress = interpolate(frame, [28, 44], [30, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  // Ripple Ring expansion
  const rippleScale = interpolate(frame, [24, 48], [1, 1.8], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });
  const rippleOpacity = interpolate(frame, [24, 48], [0.8, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // --- PAPER MATERIAL PHYSICS (Thermal Pledge Slip Ejection) ---
  // Material: Paper = 1.0x duration, subtle 3% overshoot at stop (Frames 45 to 85)
  const slipY = interpolate(frame, [45, 80], [-120, 0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.2, 0, 0, 1),
  });
  const slipOpacity = interpolate(frame, [45, 58], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  // Stamp Impact (Frames 72 to 82): Rigid material (0% overshoot, firm stop)
  const stampScale = interpolate(frame, [72, 80], [1.2, 1.0], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });
  const stampOpacity = interpolate(frame, [72, 77], [0, 1], {
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
      <Background accentColor={colors.greenSuccess} />

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
            backgroundColor: 'rgba(46, 204, 113, 0.12)',
            border: '1px solid rgba(46, 204, 113, 0.35)',
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
              backgroundColor: colors.greenSuccess,
              boxShadow: `0 0 10px ${colors.greenSuccess}`,
            }}
          />
          <span
            style={{
              color: colors.greenSuccess,
              fontFamily: fonts.mono,
              fontSize: 13,
              fontWeight: 600,
              letterSpacing: 2,
            }}
          >
            PILLAR III: MOTION CRAFT & DISNEY PHYSICS
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
            ANTICIPATION (0.96) → SQUASH/STRETCH → PAPER EJECTION
          </span>
        </div>
      </div>

      {/* Center Action Container */}
      <div
        style={{
          display: 'flex',
          gap: 60,
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 10,
        }}
      >
        {/* Left: Interactive Sanction Console */}
        <div
          style={{
            width: 480,
            backgroundColor: 'rgba(32, 20, 16, 0.94)',
            border: `1.5px solid ${colors.goldBorder}`,
            borderRadius: 20,
            padding: '36px 32px',
            boxShadow: '0 25px 60px rgba(0, 0, 0, 0.8)',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
          }}
        >
          <div
            style={{
              fontFamily: fonts.serif,
              fontSize: 24,
              color: colors.cream,
              fontWeight: 700,
              marginBottom: 8,
            }}
          >
            Disbursement Console
          </div>
          <div
            style={{
              fontFamily: fonts.sans,
              fontSize: 14,
              color: colors.textSecondary,
              marginBottom: 32,
            }}
          >
            Loan Amount Approved: ₹2,10,000.00
          </div>

          {/* CTA Button with Anticipation, Squash & State Transition */}
          <div style={{ position: 'relative' }}>
            {/* Ripple Ring */}
            {isApproved && (
              <div
                style={{
                  position: 'absolute',
                  inset: -6,
                  borderRadius: 16,
                  border: `2px solid ${colors.greenSuccess}`,
                  transform: `scale(${rippleScale})`,
                  opacity: rippleOpacity,
                  pointerEvents: 'none',
                }}
              />
            )}

            <div
              style={{
                transform: `scale(${btnScale}) scaleX(${frame >= 20 && frame < 26 ? squashX : 1}) scaleY(${frame >= 20 && frame < 26 ? squashY : 1})`,
                padding: '18px 40px',
                borderRadius: 14,
                background: isApproved
                  ? 'linear-gradient(135deg, #2ECC71 0%, #27AE60 100%)'
                  : 'linear-gradient(135deg, #F3D270 0%, #B88E1C 100%)',
                color: isApproved ? '#FFFFFF' : '#1A0F0B',
                boxShadow: isApproved
                  ? '0 10px 30px rgba(46, 204, 113, 0.4)'
                  : '0 10px 30px rgba(212, 175, 55, 0.35)',
                display: 'flex',
                alignItems: 'center',
                gap: 14,
                cursor: 'pointer',
                transition: 'background 0.2s',
              }}
            >
              {isApproved ? (
                <div
                  style={{
                    transform: `scale(${badgePopScale})`,
                    display: 'flex',
                    alignItems: 'center',
                    gap: 10,
                  }}
                >
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <circle
                      cx="12"
                      cy="12"
                      r="10"
                      stroke="#FFFFFF"
                      strokeWidth="2"
                    />
                    <path
                      d="M7 12L10.5 15.5L17 9"
                      stroke="#FFFFFF"
                      strokeWidth="2.5"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeDasharray="30"
                      strokeDashoffset={checkmarkProgress}
                    />
                  </svg>
                  <span
                    style={{
                      fontFamily: fonts.sans,
                      fontSize: 18,
                      fontWeight: 800,
                      letterSpacing: 1.5,
                    }}
                  >
                    DISBURSED & PRINTED
                  </span>
                </div>
              ) : (
                <span
                  style={{
                    fontFamily: fonts.sans,
                    fontSize: 18,
                    fontWeight: 800,
                    letterSpacing: 1.5,
                  }}
                >
                  SANCTION ₹2,10,000
                </span>
              )}
            </div>
          </div>

          <div
            style={{
              marginTop: 24,
              fontFamily: fonts.mono,
              fontSize: 12,
              color: isApproved ? colors.greenSuccess : colors.textSecondary,
              letterSpacing: 1,
            }}
          >
            {isApproved
              ? '✓ LEDGER UPDATED · CASH VOUCHER GENERATED'
              : 'READY TO DISBURSE · AWAITING TOUCH'}
          </div>
        </div>

        {/* Right: Realistic Thermal Paper Slip Ejection (Paper Physics) */}
        <div
          style={{
            width: 380,
            transform: `translateY(${slipY}px)`,
            opacity: slipOpacity,
            position: 'relative',
          }}
        >
          {/* Thermal Printer Slot Header */}
          <div
            style={{
              height: 12,
              backgroundColor: '#1E120E',
              border: `1px solid ${colors.goldBorder}`,
              borderRadius: '6px 6px 0 0',
              boxShadow: 'inset 0 4px 6px rgba(0, 0, 0, 0.8)',
            }}
          />

          {/* Thermal Receipt Body */}
          <div
            style={{
              backgroundColor: '#FDFCFA',
              color: '#1C1510',
              padding: '28px 24px',
              borderRadius: '0 0 8px 8px',
              boxShadow:
                '0 20px 40px rgba(0, 0, 0, 0.6), 0 2px 10px rgba(0, 0, 0, 0.3)',
              position: 'relative',
              overflow: 'hidden',
            }}
          >
            {/* Top zig-zag receipt pattern */}
            <div
              style={{
                fontFamily: fonts.mono,
                textAlign: 'center',
                fontSize: 12,
                color: '#8A7A70',
                letterSpacing: 2,
                marginBottom: 12,
                borderBottom: '1px dashed #D0C0B0',
                paddingBottom: 8,
              }}
            >
              TIJORI POS PRINT · LOAN SLIP
            </div>

            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                fontFamily: fonts.mono,
                fontSize: 13,
                fontWeight: 700,
                color: '#1A0F0A',
              }}
            >
              <span>LOAN NO:</span>
              <span>#GL-9840</span>
            </div>

            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                fontFamily: fonts.mono,
                fontSize: 13,
                marginTop: 6,
                color: '#3A2E26',
              }}
            >
              <span>BORROWER:</span>
              <span>Rajesh Verma</span>
            </div>

            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                fontFamily: fonts.mono,
                fontSize: 13,
                marginTop: 6,
                color: '#3A2E26',
              }}
            >
              <span>GOLD WT (NET):</span>
              <span>38.650g (22K)</span>
            </div>

            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                fontFamily: fonts.mono,
                fontSize: 14,
                fontWeight: 800,
                marginTop: 10,
                paddingTop: 8,
                borderTop: '1px dashed #D0C0B0',
                color: '#1A0F0A',
              }}
            >
              <span>DISBURSED:</span>
              <span>₹2,10,000.00</span>
            </div>

            {/* Barcode graphic */}
            <div
              style={{
                marginTop: 16,
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
                gap: 2,
                height: 36,
              }}
            >
              {[1, 3, 2, 4, 1, 2, 4, 1, 3, 2, 1, 4, 2, 3, 1, 2, 4, 2, 1, 3, 2].map(
                (w, idx) => (
                  <div
                    key={idx}
                    style={{
                      width: w,
                      height: '100%',
                      backgroundColor: '#2A1C14',
                    }}
                  />
                )
              )}
            </div>

            {/* Official Disbursed Stamp Slam */}
            <div
              style={{
                position: 'absolute',
                top: '40%',
                left: '20%',
                transform: `rotate(-12deg) scale(${stampScale})`,
                opacity: stampOpacity,
                padding: '8px 18px',
                border: '3px solid #C0392B',
                borderRadius: 8,
                color: '#C0392B',
                fontFamily: fonts.sans,
                fontSize: 18,
                fontWeight: 900,
                letterSpacing: 2,
                backgroundColor: 'rgba(255, 235, 235, 0.85)',
                boxShadow: '0 4px 12px rgba(192, 57, 43, 0.25)',
              }}
            >
              SANCTIONED
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};