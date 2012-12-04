class DubDubDub::Exception < RuntimeError; end
class DubDubDub::NotFound < DubDubDub::Exception; end
class DubDubDub::Forbidden < DubDubDub::Exception; end
class DubDubDub::Timeout < DubDubDub::Exception; end