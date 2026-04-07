import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:convert';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SpeechToText _speech = SpeechToText();

  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _isListening = false;
  bool _speechAvailable = false;

  static const String _backendUrl = kIsWeb
      ? 'http://localhost:3000/chat'
      : 'http://192.168.1.4:3000/chat';

  final List<String> _quickPrompts = [
    'వరి సాగుకు ఏ ఎరువులు వాడాలి?',
    'పంట రుణం ఎలా తీసుకోవాలి?',
    'చీడపీడల నివారణ చేయడం ఎలా?',
    'What fertilizers for rice farming?',
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final available = await _speech.initialize(
      onError: (error) => setState(() => _isListening = false),
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
    );
    setState(() => _speechAvailable = available);
  }

  Future<void> _toggleListening() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone not available')),
      );
      return;
    }
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          setState(() => _controller.text = result.recognizedWords);
          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              _sendMessage(result.recognizedWords);
            });
          }
        },
        localeId: 'en_US',
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 4),
        partialResults: true,
        cancelOnError: false,
      );
    }
  }

  Future<void> _sendMessage(String userText) async {
    if (userText.trim().isEmpty) return;
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }
    setState(() {
      _messages.add({'role': 'user', 'text': userText});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final apiMessages = _messages
          .where((m) => m['role'] == 'user' || m['role'] == 'assistant')
          .map((m) => {'role': m['role']!, 'content': m['text']!})
          .toList();

      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'messages': apiMessages}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.add({'role': 'assistant', 'text': data['reply'] as String});
          _isLoading = false;
        });
      } else {
        _showError('Server error (${response.statusCode}).');
      }
    } catch (e) {
      _showError('Cannot connect. Make sure server is running.');
    }
    _scrollToBottom();
  }

  void _showError(String msg) {
    setState(() {
      _messages.add({'role': 'error', 'text': '⚠️ $msg'});
      _isLoading = false;
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1a3a1a)),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xEE0d1f0d), Color(0xCC1a3a1a), Color(0xEE0d1f0d)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: _messages.isEmpty ? _buildEmptyState() : _buildMessageList(),
                ),
                if (_isListening) _buildListeningIndicator(),
                if (_isLoading) _buildTypingIndicator(),
                _buildInputBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.12))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('రైతు AI సహాయకుడు',
                    style: GoogleFonts.notoSansTelugu(
                        fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Farming Assistant · Guntur AP',
                    style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white60)),
              ],
            ),
          ),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.12),
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.12),
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(Icons.agriculture_rounded, size: 38, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text('నమస్కారం! నేను మీ రైతు AI సహాయకుడిని',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansTelugu(
                  fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 6),
          Text('Ask me anything in Telugu or English',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white60)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.30),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.mic_rounded, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text('మైక్ బటన్ నొక్కి మాట్లాడండి!',
                    style: GoogleFonts.notoSansTelugu(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('QUICK QUESTIONS',
                style: GoogleFonts.dmSans(
                    fontSize: 10, fontWeight: FontWeight.w600,
                    color: Colors.white60, letterSpacing: 1.2)),
          ),
          const SizedBox(height: 10),
          ..._quickPrompts.map((q) => GestureDetector(
            onTap: () => _sendMessage(q),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.30),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 15, color: Colors.white60),
                  const SizedBox(width: 10),
                  Expanded(child: Text(q,
                      style: GoogleFonts.notoSansTelugu(fontSize: 12, color: Colors.white))),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: Colors.white38),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (_, i) {
        final msg = _messages[i];
        return _buildBubble(
            msg['text'] ?? '', msg['role'] == 'user', msg['role'] == 'error');
      },
    );
  }

  Widget _buildBubble(String text, bool isUser, bool isError) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isError
              ? Colors.red.withOpacity(0.25)
              : isUser
                  ? Colors.white.withOpacity(0.90)
                  : Colors.black.withOpacity(0.45),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          border: Border.all(
            color: isUser ? Colors.transparent : Colors.white.withOpacity(0.15),
          ),
        ),
        child: Text(text,
            style: GoogleFonts.notoSansTelugu(
                fontSize: 13,
                color: isError
                    ? const Color(0xFFff9090)
                    : isUser
                        ? const Color(0xFF1a3a1a)
                        : Colors.white,
                height: 1.5)),
      ),
    );
  }

  Widget _buildListeningIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.30)),
      ),
      child: Row(
        children: [
          const Icon(Icons.mic_rounded, color: Color(0xFFff9090), size: 16),
          const SizedBox(width: 8),
          Text('వింటున్నాను... మాట్లాడండి',
              style: GoogleFonts.notoSansTelugu(fontSize: 12, color: const Color(0xFFff9090))),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16, height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white60),
          ),
          const SizedBox(width: 10),
          Text('AI ఆలోచిస్తోంది...',
              style: GoogleFonts.notoSansTelugu(fontSize: 12, color: Colors.white60)),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.40),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.12))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggleListening,
            child: Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening
                    ? Colors.red.withOpacity(0.30)
                    : Colors.white.withOpacity(0.15),
                border: Border.all(
                  color: _isListening ? Colors.red.withOpacity(0.50) : Colors.white24,
                ),
              ),
              child: Icon(
                _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                color: _isListening ? const Color(0xFFff9090) : Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.20)),
              ),
              child: TextField(
                controller: _controller,
                style: GoogleFonts.notoSansTelugu(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: _isListening ? 'వింటున్నాను... 🎤' : 'మీ ప్రశ్న అడగండి...',
                  hintStyle: GoogleFonts.notoSansTelugu(fontSize: 12, color: Colors.white38),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(_controller.text),
            child: Container(
              width: 46, height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.send_rounded, color: Color(0xFF1a3a1a), size: 20),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _speech.stop();
    super.dispose();
  }
}