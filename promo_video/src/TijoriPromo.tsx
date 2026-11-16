import React from 'react';
import { Sequence } from 'remotion';
import { Scene1Hook } from './scenes/Scene1Hook';
import { Scene2Reveal } from './scenes/Scene2Reveal';
import { Scene3RatesAndValuation } from './scenes/Scene3RatesAndValuation';
import { Scene4PledgeSlip } from './scenes/Scene4PledgeSlip';
import { Scene5Karigar } from './scenes/Scene5Karigar';
import { Scene6GSTAndCash } from './scenes/Scene6GSTAndCash';
import { Scene7CTA } from './scenes/Scene7CTA';

export const TijoriPromo: React.FC = () => {
  return (
    <div
      style={{
        flex: 1,
        backgroundColor: '#110A08',
        width: 1920,
        height: 1080,
      }}
    >
      {/* Scene 1: The Problem / Pain Point (0s - 4.0s) */}
      <Sequence from={0} durationInFrames={120}>
        <Scene1Hook />
      </Sequence>

      {/* Scene 2: The Reveal - Introducing TIJORI (4.0s - 8.0s) */}
      <Sequence from={120} durationInFrames={120}>
        <Scene2Reveal />
      </Sequence>

      {/* Scene 3: Daily Metal Rates & Smart Calculation (8.0s - 13.0s) */}
      <Sequence from={240} durationInFrames={150}>
        <Scene3RatesAndValuation />
      </Sequence>

      {/* Scene 4: Instant Thermal Pledge Slip & Photo Vault (13.0s - 18.0s) */}
      <Sequence from={390} durationInFrames={150}>
        <Scene4PledgeSlip />
      </Sequence>

      {/* Scene 5: Karigar Pure Gold Ledger & Hisaab (18.0s - 23.0s) */}
      <Sequence from={540} durationInFrames={150}>
        <Scene5Karigar />
      </Sequence>

      {/* Scene 6: GST Compliance & Daily Cash Drawer (23.0s - 26.0s) */}
      <Sequence from={690} durationInFrames={90}>
        <Scene6GSTAndCash />
      </Sequence>

      {/* Scene 7: Grand Finale & Call to Action (26.0s - 30.0s) */}
      <Sequence from={780} durationInFrames={120}>
        <Scene7CTA />
      </Sequence>
    </div>
  );
};
