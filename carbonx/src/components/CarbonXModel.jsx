import '@google/model-viewer';
import { useEffect } from 'react';

export function CarbonXModel({ modelPath, posterPath }) {
  useEffect(() => {
    const modelViewer = document.querySelector('model-viewer');
    
    const handleLoad = () => {
      console.log('Model loaded successfully');
    };

    const handleError = (error) => {
      console.error('Error loading model:', error);
    };

    // Disable double-click zoom behavior
    const preventDoubleClick = (e) => {
      e.preventDefault();
    };

    if (modelViewer) {
      modelViewer.addEventListener('load', handleLoad);
      modelViewer.addEventListener('error', handleError);
      modelViewer.addEventListener('dblclick', preventDoubleClick);

      // Add interaction change handler
      modelViewer.addEventListener('camera-change', () => {
        // Reset auto-rotation delay to 0 for immediate resumption
        modelViewer.autoRotateDelay = 0;
      });
    }

    return () => {
      if (modelViewer) {
        modelViewer.removeEventListener('load', handleLoad);
        modelViewer.removeEventListener('error', handleError);
        modelViewer.removeEventListener('dblclick', preventDoubleClick);
      }
    };
  }, []);

  return (
    <div className="model-viewer-container w-full h-full">
      <model-viewer
        src={modelPath}
        poster={posterPath}
        auto-rotate
        rotation-per-second="30deg"
        auto-rotate-delay="0"
        interaction-prompt="none"
        camera-orbit="0deg 75deg 105%"
        min-camera-orbit="auto auto 105%"
        max-camera-orbit="auto auto 105%"
        camera-controls="auto"
        touch-action="pan-y"
        disable-zoom
        disable-tap
        interpolation-decay="0.9"
        orbit-sensitivity="1"
        camera-target="0m 0m 0m"
        interaction-policy="allow-when-focused"
        environment-image="neutral"
        skybox-image=""
        shadow-intensity="0"
        exposure="1"
        style={{
          width: '100%',
          height: '100%',
          background: 'transparent',
          '--poster-color': 'transparent',
          cursor: 'move'
        }}
      >
        <div className="progress-bar hide" slot="progress-bar">
          <div className="update-bar"></div>
        </div>
      </model-viewer>

      <style jsx>{`
        .model-viewer-container {
          position: relative;
          overflow: visible;
          background: transparent;
        }

        model-viewer {
          --progress-bar-color: linear-gradient(to right, #76EAD7, #C4FB6D);
          --progress-mask: linear-gradient(to right, transparent 0%, #000 50%, transparent 100%);
          --poster-color: transparent;
          background-color: transparent;
          --interaction-prompt-threshold: 0;
          --interaction-prompt: none;
          --min-field-of-view: 10deg;
          --max-field-of-view: 90deg;
          --interpolation-speed: 100;
        }

        model-viewer::part(default-progress-bar) {
          display: none;
        }

        .progress-bar {
          position: absolute;
          left: 0;
          bottom: 0;
          width: 100%;
          height: 4px;
          background: rgba(255, 255, 255, 0.1);
          transition: transform 0.3s;
        }

        .progress-bar.hide {
          transform: translateY(100%);
        }

        .update-bar {
          background: linear-gradient(to right, #76EAD7, #C4FB6D);
          width: 100%;
          height: 100%;
          transform-origin: left;
          animation: update-progress 2s linear infinite;
        }

        @keyframes update-progress {
          0% { transform: scaleX(0); }
          100% { transform: scaleX(1); }
        }
      `}</style>
    </div>
  );
} 