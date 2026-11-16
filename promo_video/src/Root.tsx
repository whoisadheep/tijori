import React from 'react';
import { Composition } from 'remotion';
import { TijoriPromo } from './TijoriPromo';
import { MotionDesignShowcase } from './MotionDesignShowcase';

export const Root: React.FC = () => {
  return (
    <>
      <Composition
        id="MotionDesignShowcase"
        component={MotionDesignShowcase}
        durationInFrames={480}
        fps={30}
        width={1920}
        height={1080}
      />
      <Composition
        id="TijoriPromo"
        component={TijoriPromo}
        durationInFrames={900}
        fps={30}
        width={1920}
        height={1080}
      />
    </>
  );
};