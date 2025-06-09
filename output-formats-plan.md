# Enhanced Output Formats & Content Generation Plan

## 1. Architecture for Multi-Format Output

### A. Output Format Engine
```typescript
// lib/output-formatter.ts
export interface OutputFormat {
  id: string;
  name: string;
  description: string;
  generate: (research: ResearchResult) => Promise<FormattedOutput>;
  preview: boolean;
}

export class OutputFormatter {
  private formats: Map<string, OutputFormat>;
  
  constructor() {
    this.formats = new Map();
    this.registerFormats();
  }
  
  async generateOutput(
    research: ResearchResult, 
    formatIds: string[]
  ): Promise<FormattedOutput[]> {
    const results = await Promise.all(
      formatIds.map(id => {
        const format = this.formats.get(id);
        if (!format) throw new Error(`Format ${id} not found`);
        return format.generate(research);
      })
    );
    return results;
  }
}
```

### B. Extend Search State for Output
```typescript
// In SearchStateAnnotation
outputFormats: Annotation<string[]>({
  reducer: (x, y) => y ?? x,
  default: () => ['standard'] // Default to current format
}),
generatedOutputs: Annotation<FormattedOutput[]>({
  reducer: (existing, update) => [...existing, ...update],
  default: () => []
}),
outputContext: Annotation<OutputContext>({
  reducer: (x, y) => ({ ...x, ...y }),
  default: () => ({
    tone: 'professional',
    audience: 'general',
    intent: 'inform'
  })
})
```

### C. Add Output Generation Node
```typescript
// Add to buildGraph()
.addNode("generateOutputs", async (state: SearchState, config?: GraphConfig) => {
  const eventCallback = config?.configurable?.eventCallback;
  
  if (eventCallback) {
    eventCallback({
      type: 'output-generation',
      message: 'Generating formatted outputs...'
    });
  }
  
  const formatter = new OutputFormatter();
  const research: ResearchResult = {
    query: state.query,
    understanding: state.understanding,
    sources: state.processedSources || [],
    answer: state.finalAnswer || '',
    followUpQuestions: state.followUpQuestions
  };
  
  const outputs = await formatter.generateOutput(
    research,
    state.outputFormats
  );
  
  return {
    generatedOutputs: outputs,
    phase: 'complete' as SearchPhase
  };
})
```

## 2. Output Format Implementations

### A. Social Media Formats

```typescript
// lib/formats/social-media.ts

export const twitterThreadFormat: OutputFormat = {
  id: 'twitter-thread',
  name: 'Twitter/X Thread',
  description: 'Multi-tweet thread with citations',
  preview: true,
  
  async generate(research: ResearchResult): Promise<FormattedOutput> {
    const tweets: string[] = [];
    const maxLength = 280;
    
    // Opening tweet
    tweets.push(this.createHookTweet(research.query, research.answer));
    
    // Break down key points into tweets
    const keyPoints = this.extractKeyPoints(research.answer);
    keyPoints.forEach((point, index) => {
      tweets.push(this.formatTweet(point, index + 1, keyPoints.length));
    });
    
    // Sources tweet
    tweets.push(this.createSourcesTweet(research.sources));
    
    // Call to action
    tweets.push(this.createCTATweet(research.followUpQuestions));
    
    return {
      format: 'twitter-thread',
      content: tweets,
      metadata: {
        tweetCount: tweets.length,
        estimatedReadTime: tweets.length * 5 // seconds
      }
    };
  }
};

export const linkedInPostFormat: OutputFormat = {
  id: 'linkedin-post',
  name: 'LinkedIn Article',
  description: 'Professional article with insights',
  preview: true,
  
  async generate(research: ResearchResult): Promise<FormattedOutput> {
    const sections = [
      this.createHeadline(research.query),
      this.createExecutiveSummary(research.answer),
      this.createKeyInsights(research),
      this.createImplications(research),
      this.createConclusion(research)
    ];
    
    return {
      format: 'linkedin-post',
      content: sections.join('\n\n'),
      metadata: {
        wordCount: this.countWords(sections),
        readingTime: Math.ceil(this.countWords(sections) / 200),
        hashtags: this.generateHashtags(research)
      }
    };
  }
};
```

### B. Email Campaign Format

```typescript
// lib/formats/email-campaign.ts

export const emailCampaignFormat: OutputFormat = {
  id: 'email-campaign',
  name: 'Email Campaign Series',
  description: 'Multi-email nurture sequence',
  preview: true,
  
  async generate(research: ResearchResult): Promise<FormattedOutput> {
    const emails = [
      {
        subject: this.generateSubjectLine(research.query, 'awareness'),
        preheader: this.generatePreheader(research),
        body: this.createAwarenessEmail(research),
        sequence: 1,
        sendAfter: 0
      },
      {
        subject: this.generateSubjectLine(research.query, 'education'),
        preheader: this.generatePreheader(research, 'education'),
        body: this.createEducationEmail(research),
        sequence: 2,
        sendAfter: 3 // days
      },
      {
        subject: this.generateSubjectLine(research.query, 'decision'),
        preheader: this.generatePreheader(research, 'decision'),
        body: this.createDecisionEmail(research),
        sequence: 3,
        sendAfter: 7
      }
    ];
    
    return {
      format: 'email-campaign',
      content: emails,
      metadata: {
        campaignLength: emails.length,
        totalDuration: 7,
        personalizationTokens: this.extractTokens(emails)
      }
    };
  }
};
```

### C. Landing Page Format

```typescript
// lib/formats/landing-page.ts

export const landingPageFormat: OutputFormat = {
  id: 'landing-page',
  name: 'Landing Page',
  description: 'Complete HTML landing page with sections',
  preview: true,
  
  async generate(research: ResearchResult): Promise<FormattedOutput> {
    const page = {
      hero: {
        headline: this.createHeadline(research),
        subheadline: this.createSubheadline(research),
        cta: this.generateCTA(research)
      },
      sections: [
        {
          type: 'problem',
          content: this.createProblemSection(research)
        },
        {
          type: 'solution',
          content: this.createSolutionSection(research)
        },
        {
          type: 'benefits',
          content: this.createBenefitsSection(research)
        },
        {
          type: 'proof',
          content: this.createProofSection(research.sources)
        },
        {
          type: 'faq',
          content: this.createFAQSection(research.followUpQuestions)
        }
      ],
      styles: this.generateStyles(research),
      scripts: this.generateScripts()
    };
    
    const html = this.renderToHTML(page);
    
    return {
      format: 'landing-page',
      content: html,
      metadata: {
        sections: page.sections.length,
        hasVideo: false,
        mobileOptimized: true,
        seoScore: this.calculateSEOScore(page)
      }
    };
  }
};
```

### D. Presentation Format

```typescript
// lib/formats/presentation.ts

export const presentationFormat: OutputFormat = {
  id: 'presentation',
  name: 'Slide Presentation',
  description: 'PowerPoint/Google Slides format',
  preview: true,
  
  async generate(research: ResearchResult): Promise<FormattedOutput> {
    const slides = [
      this.createTitleSlide(research),
      this.createAgendaSlide(research),
      ...this.createContentSlides(research),
      this.createSummarySlide(research),
      this.createSourcesSlide(research.sources),
      this.createQASlide(research.followUpQuestions)
    ];
    
    return {
      format: 'presentation',
      content: slides,
      metadata: {
        slideCount: slides.length,
        estimatedDuration: slides.length * 2, // minutes
        visualsNeeded: this.identifyVisuals(slides),
        speakerNotes: this.generateSpeakerNotes(slides)
      }
    };
  }
};
```

## 3. Smart Format Selection

```typescript
// lib/format-selector.ts
export class FormatSelector {
  async recommendFormats(
    query: string,
    understanding: string,
    context?: OutputContext
  ): Promise<string[]> {
    const analysis = await this.analyzeIntent(query, understanding);
    
    const recommendations: string[] = [];
    
    // Business/Professional queries
    if (analysis.isProfessional) {
      recommendations.push('linkedin-post', 'presentation', 'report');
    }
    
    // Marketing/Promotional queries
    if (analysis.isMarketing) {
      recommendations.push('landing-page', 'email-campaign', 'social-ads');
    }
    
    // Educational/Informative queries
    if (analysis.isEducational) {
      recommendations.push('blog-post', 'infographic', 'video-script');
    }
    
    // News/Updates queries
    if (analysis.isNews) {
      recommendations.push('twitter-thread', 'newsletter', 'press-release');
    }
    
    return recommendations;
  }
}
```

## 4. UI Integration

```typescript
// app/output-selector.tsx
export function OutputSelector({ 
  onFormatSelect,
  recommendedFormats,
  research 
}: OutputSelectorProps) {
  const [selectedFormats, setSelectedFormats] = useState<string[]>([]);
  const [previews, setPreviews] = useState<Map<string, FormattedOutput>>();
  
  return (
    <div className="output-selector">
      <h3>Choose Output Formats</h3>
      
      <div className="recommended-formats">
        <h4>Recommended for your query:</h4>
        {recommendedFormats.map(format => (
          <FormatCard
            key={format}
            format={format}
            isRecommended
            onSelect={() => toggleFormat(format)}
            onPreview={() => generatePreview(format)}
          />
        ))}
      </div>
      
      <div className="all-formats">
        <h4>All formats:</h4>
        {/* Grid of all available formats */}
      </div>
      
      <div className="format-previews">
        {selectedFormats.map(format => (
          <FormatPreview
            key={format}
            format={format}
            preview={previews.get(format)}
          />
        ))}
      </div>
      
      <Button onClick={() => onFormatSelect(selectedFormats)}>
        Generate Selected Formats
      </Button>
    </div>
  );
}
```

## 5. Output Quality Enhancements

### A. Context-Aware Generation
```typescript
const contextualGeneration = {
  audience: {
    technical: { jargon: 'high', depth: 'detailed', examples: 'code' },
    business: { jargon: 'medium', depth: 'summary', examples: 'case-studies' },
    general: { jargon: 'low', depth: 'overview', examples: 'analogies' }
  },
  
  tone: {
    professional: { formality: 'high', personality: 'low' },
    conversational: { formality: 'medium', personality: 'high' },
    academic: { formality: 'high', personality: 'low', citations: 'required' }
  },
  
  intent: {
    inform: { structure: 'logical', emotion: 'low', cta: 'subtle' },
    persuade: { structure: 'problem-solution', emotion: 'high', cta: 'strong' },
    entertain: { structure: 'narrative', emotion: 'high', cta: 'optional' }
  }
};
```

### B. Quality Scoring
```typescript
interface QualityMetrics {
  readability: number;      // Flesch-Kincaid score
  engagement: number;       // Based on structure, hooks, CTAs
  seoOptimization: number;  // Keywords, meta, structure
  accessibility: number;    // Alt text, headers, contrast
  accuracy: number;         // Source citation coverage
}

export function scoreOutputQuality(
  output: FormattedOutput
): QualityMetrics {
  return {
    readability: calculateReadability(output.content),
    engagement: scoreEngagement(output),
    seoOptimization: scoreSEO(output),
    accessibility: scoreAccessibility(output),
    accuracy: scoreAccuracy(output)
  };
}
```

## 6. Benefits

1. **Versatility**: One research effort → multiple content pieces
2. **Efficiency**: Save hours of content creation time
3. **Consistency**: Maintain message across all formats
4. **Optimization**: Each format optimized for its platform
5. **Personalization**: Adapt tone/style for different audiences
6. **Measurability**: Track performance across formats 