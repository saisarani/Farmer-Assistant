const express = require('express');
const cors = require('cors');
const Groq = require('groq-sdk');

const app = express();
app.use(cors({ origin: '*' }));
app.use(express.json({ limit: '20mb' }));

const GROQ_API_KEY = 'YOUR_GROQ_API_KEY'; // ← your Groq key here

const groq = new Groq({ apiKey: GROQ_API_KEY });

const SYSTEM_PROMPT = 'You are Rythu AI Assistant, a helpful farming assistant for farmers in Guntur, Andhra Pradesh, India. Detect the language of the user message. If user writes in English - reply in English. If user writes in Telugu - reply in Telugu. Keep answers practical and helpful for farmers.';

// ── Chat endpoint ─────────────────────────────────────────────────────────
app.post('/chat', async (req, res) => {
  try {
    const { messages } = req.body;
    const response = await groq.chat.completions.create({
      model: 'llama-3.3-70b-versatile',
      messages: [
        { role: 'system', content: SYSTEM_PROMPT },
        ...messages.map(m => ({ role: m.role, content: m.content })),
      ],
    });
    res.json({ reply: response.choices[0].message.content });
  } catch (err) {
    console.error('Chat error:', err.message);
    res.status(500).json({ error: err.message });
  }
});

// ── Disease detection endpoint (Groq Vision) ──────────────────────────────
app.post('/detect-disease', async (req, res) => {
  try {
    const { imageBase64, mimeType, language } = req.body;

    const prompt = language === 'te'
      ? 'ఈ పంట ఆకు/మొక్క చిత్రాన్ని విశ్లేషించండి. వ్యాధి పేరు, లక్షణాలు మరియు చికిత్స తెలుగులో చెప్పండి. JSON format లో మాత్రమే ఇవ్వండి, వేరే text వద్దు: {"disease": "వ్యాధి పేరు", "severity": "తక్కువ లేదా మధ్యమ లేదా అధిక", "symptoms": "లక్షణాలు", "treatment": "చికిత్స", "prevention": "నివారణ"}'
      : 'Analyze this crop leaf/plant image carefully. Identify any disease, pest damage, or nutritional deficiency. Respond in JSON format ONLY with no extra text, no markdown, no explanation: {"disease": "disease name or Healthy", "severity": "Low or Medium or High or None", "symptoms": "visible symptoms description", "treatment": "recommended treatment steps", "prevention": "prevention tips"}';

    const response = await groq.chat.completions.create({
      model: 'meta-llama/llama-4-scout-17b-16e-instruct',
      messages: [
        {
          role: 'user',
          content: [
            {
              type: 'image_url',
              image_url: {
                url: `data:${mimeType || 'image/jpeg'};base64,${imageBase64}`,
              },
            },
            {
              type: 'text',
              text: prompt,
            },
          ],
        },
      ],
      max_tokens: 1024,
    });

    let text = response.choices[0].message.content;
    console.log('Vision response:', text.substring(0, 200));

    text = text.replace(/```json|```/g, '').trim();

    try {
      const result = JSON.parse(text);
      res.json(result);
    } catch {
      res.json({
        disease: 'Analysis Complete',
        severity: 'Unknown',
        symptoms: text,
        treatment: 'Please consult your local agricultural officer.',
        prevention: 'Maintain proper crop hygiene.',
      });
    }
  } catch (err) {
    console.error('Disease detection error:', err.message);
    res.status(500).json({ error: err.message });
  }
});

app.listen(3000, () => console.log('✅ Server running on http://localhost:3000'));