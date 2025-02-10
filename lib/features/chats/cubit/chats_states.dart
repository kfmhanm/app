abstract class ChatsStates {}

class ChatsInitial extends ChatsStates {}

class ChatsLoading extends ChatsStates {}

class ChatsDone extends ChatsStates {}

class ChatsError extends ChatsStates {}

class ReceivedMessageState extends ChatsStates {}

class MessageLoadingState extends ChatsStates {}

class MessageSentState extends ChatsStates {}

class MessageSentErrorState extends ChatsStates {}

class ChatSuccessState extends ChatsStates {}

class ChatLoadingState extends ChatsStates {}

class ChatErrorState extends ChatsStates {}
