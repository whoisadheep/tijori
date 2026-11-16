import React from 'react';
import { Sequence } from 'remotion';
import { MotionScene1Vault } from './motion_scenes/MotionScene1Vault';
import { MotionScene2Valuation } from './motion_scenes/MotionScene2Valuation';
import { MotionScene3Disbursement } from './motion_scenes/MotionScene3Disbursement';
import { MotionScene4Finale } from './motion_scenes/MotionScene4Finale';

/**
 * Tijori Motion Design Showcase
 * Implements LottieFiles Motion Design Skill principles:
 * - 3 Pillars: Emotional Intent, Visual Narrative, Motion Craft
 * - 3 Layers: Primary, Secondary (shadow lag, gleam shimmer), Ambient (dust motes, breathing)
 * - Archetype: Premium [cubic-bezier(0.4, 0, 0.2, 1)]
 * - Disney Principles: Anticipation (0.96 scale down), Squash & Stretch, Staging, Follow-Through
 * - 1/3 Rules: Distance < 35px, elements < 1/3 simultaneous, stagger budget < 300ms
 */
export const MotionDesignShowcase: React.FC = () => {
  return (
    <div
      style={{
        flex: 1,
        backgroundColor: '#110A08',
        width: 1920,
        height: 1080,
      }}
    >
      {/* Act 1: The Golden Vault & Three Pillars (0.0s - 4.0s) */}
      <Sequence from={0} durationInFrames={120}>
        <MotionScene1Vault />
      </Sequence>

      {/* Act 2: Multi-Element Choreography & 1/3 Rule (4.0s - 8.0s) */}
      <Sequence from={120} durationInFrames={120}>
        <MotionScene2Valuation />
      </Sequence>

      {/* Act 3: Disney Principles & Tactile State Transition (8.0s - 12.0s) */}
      <Sequence from={240} durationInFrames={120}>
        <MotionScene3Disbursement />
      </Sequence>

      {/* Act 4: Kinetic Typography & Grand Brand Climax (12.0s - 16.0s) */}
      <Sequence from={360} durationInFrames={120}>
        <MotionScene4Finale />
      </Sequence>
    </div>
  );
};