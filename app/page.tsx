import { Chat } from './chat';
import Image from 'next/image';

export default function Home() {
  return (
    <div className="min-h-screen flex flex-col">
      {/* Header with logo */}
      <header className="px-4 sm:px-6 lg:px-8 py-4">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <a
            href="https://firecrawl.dev"
            target="_blank"
            rel="noopener noreferrer"
          >
            <Image
              src="/firecrawl-logo-with-fire.png"
              alt="Firecrawl Logo"
              width={113}
              height={24}
              className="w-[113px] h-auto"
            />
          </a>

        </div>
      </header>

      {/* Hero section */}
      <div className="px-4 sm:px-6 lg:px-8 pt-8 pb-6">
        <div className="max-w-4xl mx-auto text-center">
          <h1 className="text-[2.5rem] lg:text-[3.8rem] text-[#36322F] dark:text-white font-semibold tracking-tight leading-[0.9] opacity-0 animate-fade-up [animation-duration:500ms] [animation-delay:200ms] [animation-fill-mode:forwards]">
            <span className="relative px-1 text-transparent bg-clip-text bg-gradient-to-tr from-red-600 to-yellow-500 inline-flex justify-center items-center">
              Toby 2.0 Deep Research
            </span>
            <span className="block leading-[1.1] opacity-0 animate-fade-up [animation-duration:500ms] [animation-delay:400ms] [animation-fill-mode:forwards]">
              Deep Research
            </span>
          </h1>
          <p className="mt-6 text-lg text-zinc-600 dark:text-zinc-400 opacity-0 animate-fade-up [animation-duration:500ms] [animation-delay:600ms] [animation-fill-mode:forwards]">
            AI-powered search powered by Voyager Social & Toby AI
          </p>
        </div>
      </div>

      {/* Main content wrapper */}
      <div className="flex-1">
        {/* Chat component */}
        <Chat />
      </div>

      {/* Footer */}
      <footer className="px-4 sm:px-6 lg:px-8 py-8 mt-auto">
        <div className="max-w-4xl mx-auto text-center">
          <p className="text-sm text-gray-600 dark:text-gray-400">
            Powered by{' '}
            <a
              href="https://www.voyagersocial.ai"
              target="_blank"
              rel="noopener noreferrer"
              className="text-orange-600 hover:text-orange-700 dark:text-orange-400 dark:hover:text-orange-300 font-medium"
            >
              Voyager Social
            </a>
            {' and '}
            <a
              href="https://www.voyagersocial.ai"
              target="_blank"
              rel="noopener noreferrer"
              className="text-orange-600 hover:text-orange-700 dark:text-orange-400 dark:hover:text-orange-300 font-medium"
            >
              Toby AI
            </a>
          </p>
        </div>
      </footer>
    </div>
  );
}