
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 40 e0 10 80       	mov    $0x8010e040,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 5e 39 10 80       	mov    $0x8010395e,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 84 89 10 80       	push   $0x80108984
80100042:	68 40 e0 10 80       	push   $0x8010e040
80100047:	e8 40 51 00 00       	call   8010518c <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 50 1f 11 80 44 	movl   $0x80111f44,0x80111f50
80100056:	1f 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 54 1f 11 80 44 	movl   $0x80111f44,0x80111f54
80100060:	1f 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 74 e0 10 80 	movl   $0x8010e074,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 54 1f 11 80    	mov    0x80111f54,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 44 1f 11 80 	movl   $0x80111f44,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 54 1f 11 80       	mov    0x80111f54,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 54 1f 11 80       	mov    %eax,0x80111f54
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 44 1f 11 80       	mov    $0x80111f44,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 40 e0 10 80       	push   $0x8010e040
801000c1:	e8 e8 50 00 00       	call   801051ae <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 54 1f 11 80       	mov    0x80111f54,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 40 e0 10 80       	push   $0x8010e040
8010010c:	e8 04 51 00 00       	call   80105215 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 40 e0 10 80       	push   $0x8010e040
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 89 4d 00 00       	call   80104eb5 <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 44 1f 11 80 	cmpl   $0x80111f44,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 50 1f 11 80       	mov    0x80111f50,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 40 e0 10 80       	push   $0x8010e040
80100188:	e8 88 50 00 00       	call   80105215 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 44 1f 11 80 	cmpl   $0x80111f44,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 8b 89 10 80       	push   $0x8010898b
801001af:	e8 2e 04 00 00       	call   801005e2 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 a2 27 00 00       	call   80102989 <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 9c 89 10 80       	push   $0x8010899c
80100209:	e8 d4 03 00 00       	call   801005e2 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 61 27 00 00       	call   80102989 <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 a3 89 10 80       	push   $0x801089a3
80100248:	e8 95 03 00 00       	call   801005e2 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 40 e0 10 80       	push   $0x8010e040
80100255:	e8 54 4f 00 00       	call   801051ae <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 54 1f 11 80    	mov    0x80111f54,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 44 1f 11 80 	movl   $0x80111f44,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 54 1f 11 80       	mov    0x80111f54,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 54 1f 11 80       	mov    %eax,0x80111f54

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 e2 4c 00 00       	call   80104fa0 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 40 e0 10 80       	push   $0x8010e040
801002c9:	e8 47 4f 00 00       	call   80105215 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 5b 04 00 00       	call   8010080e <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <printlong>:

static void
printlong(unsigned long long xx, int base, int sgn)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
801003cc:	8b 45 08             	mov    0x8(%ebp),%eax
801003cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
801003d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801003d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
801003d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801003db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801003de:	89 d0                	mov    %edx,%eax
801003e0:	31 d2                	xor    %edx,%edx
801003e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
801003e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801003e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(upper, 16, 0);
801003eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003ef:	74 13                	je     80100404 <printlong+0x3e>
801003f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003f4:	83 ec 04             	sub    $0x4,%esp
801003f7:	6a 00                	push   $0x0
801003f9:	6a 10                	push   $0x10
801003fb:	50                   	push   %eax
801003fc:	e8 16 ff ff ff       	call   80100317 <printint>
80100401:	83 c4 10             	add    $0x10,%esp
    printint(lower, 16, 0);
80100404:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100407:	83 ec 04             	sub    $0x4,%esp
8010040a:	6a 00                	push   $0x0
8010040c:	6a 10                	push   $0x10
8010040e:	50                   	push   %eax
8010040f:	e8 03 ff ff ff       	call   80100317 <printint>
80100414:	83 c4 10             	add    $0x10,%esp
}
80100417:	90                   	nop
80100418:	c9                   	leave  
80100419:	c3                   	ret    

8010041a <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
8010041a:	55                   	push   %ebp
8010041b:	89 e5                	mov    %esp,%ebp
8010041d:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100420:	a1 14 c6 10 80       	mov    0x8010c614,%eax
80100425:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
80100428:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010042c:	74 10                	je     8010043e <cprintf+0x24>
    acquire(&cons.lock);
8010042e:	83 ec 0c             	sub    $0xc,%esp
80100431:	68 e0 c5 10 80       	push   $0x8010c5e0
80100436:	e8 73 4d 00 00       	call   801051ae <acquire>
8010043b:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
8010043e:	8b 45 08             	mov    0x8(%ebp),%eax
80100441:	85 c0                	test   %eax,%eax
80100443:	75 0d                	jne    80100452 <cprintf+0x38>
    panic("null fmt");
80100445:	83 ec 0c             	sub    $0xc,%esp
80100448:	68 aa 89 10 80       	push   $0x801089aa
8010044d:	e8 90 01 00 00       	call   801005e2 <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100452:	8d 45 0c             	lea    0xc(%ebp),%eax
80100455:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100458:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010045f:	e9 42 01 00 00       	jmp    801005a6 <cprintf+0x18c>
    if(c != '%'){
80100464:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100468:	74 13                	je     8010047d <cprintf+0x63>
      consputc(c);
8010046a:	83 ec 0c             	sub    $0xc,%esp
8010046d:	ff 75 e4             	pushl  -0x1c(%ebp)
80100470:	e8 99 03 00 00       	call   8010080e <consputc>
80100475:	83 c4 10             	add    $0x10,%esp
      continue;
80100478:	e9 25 01 00 00       	jmp    801005a2 <cprintf+0x188>
    }
    c = fmt[++i] & 0xff;
8010047d:	8b 55 08             	mov    0x8(%ebp),%edx
80100480:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100484:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100487:	01 d0                	add    %edx,%eax
80100489:	0f b6 00             	movzbl (%eax),%eax
8010048c:	0f be c0             	movsbl %al,%eax
8010048f:	25 ff 00 00 00       	and    $0xff,%eax
80100494:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100497:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010049b:	0f 84 27 01 00 00    	je     801005c8 <cprintf+0x1ae>
      break;
    switch(c){
801004a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004a4:	83 f8 6c             	cmp    $0x6c,%eax
801004a7:	74 4c                	je     801004f5 <cprintf+0xdb>
801004a9:	83 f8 6c             	cmp    $0x6c,%eax
801004ac:	7f 13                	jg     801004c1 <cprintf+0xa7>
801004ae:	83 f8 25             	cmp    $0x25,%eax
801004b1:	0f 84 c0 00 00 00    	je     80100577 <cprintf+0x15d>
801004b7:	83 f8 64             	cmp    $0x64,%eax
801004ba:	74 19                	je     801004d5 <cprintf+0xbb>
801004bc:	e9 c5 00 00 00       	jmp    80100586 <cprintf+0x16c>
801004c1:	83 f8 73             	cmp    $0x73,%eax
801004c4:	74 6f                	je     80100535 <cprintf+0x11b>
801004c6:	83 f8 78             	cmp    $0x78,%eax
801004c9:	74 4d                	je     80100518 <cprintf+0xfe>
801004cb:	83 f8 70             	cmp    $0x70,%eax
801004ce:	74 48                	je     80100518 <cprintf+0xfe>
801004d0:	e9 b1 00 00 00       	jmp    80100586 <cprintf+0x16c>
    case 'd':
      printint(*argp++, 10, 1);
801004d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004d8:	8d 50 04             	lea    0x4(%eax),%edx
801004db:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004de:	8b 00                	mov    (%eax),%eax
801004e0:	83 ec 04             	sub    $0x4,%esp
801004e3:	6a 01                	push   $0x1
801004e5:	6a 0a                	push   $0xa
801004e7:	50                   	push   %eax
801004e8:	e8 2a fe ff ff       	call   80100317 <printint>
801004ed:	83 c4 10             	add    $0x10,%esp
      break;
801004f0:	e9 ad 00 00 00       	jmp    801005a2 <cprintf+0x188>
    case 'l':
        printlong(*(unsigned long long *)argp, 10, 0);
801004f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004f8:	8b 50 04             	mov    0x4(%eax),%edx
801004fb:	8b 00                	mov    (%eax),%eax
801004fd:	6a 00                	push   $0x0
801004ff:	6a 0a                	push   $0xa
80100501:	52                   	push   %edx
80100502:	50                   	push   %eax
80100503:	e8 be fe ff ff       	call   801003c6 <printlong>
80100508:	83 c4 10             	add    $0x10,%esp
        // long longs take up 2 argument slots
        argp++;
8010050b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
        argp++;
8010050f:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
        break;
80100513:	e9 8a 00 00 00       	jmp    801005a2 <cprintf+0x188>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100518:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010051b:	8d 50 04             	lea    0x4(%eax),%edx
8010051e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100521:	8b 00                	mov    (%eax),%eax
80100523:	83 ec 04             	sub    $0x4,%esp
80100526:	6a 00                	push   $0x0
80100528:	6a 10                	push   $0x10
8010052a:	50                   	push   %eax
8010052b:	e8 e7 fd ff ff       	call   80100317 <printint>
80100530:	83 c4 10             	add    $0x10,%esp
      break;
80100533:	eb 6d                	jmp    801005a2 <cprintf+0x188>
    case 's':
      if((s = (char*)*argp++) == 0)
80100535:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100538:	8d 50 04             	lea    0x4(%eax),%edx
8010053b:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010053e:	8b 00                	mov    (%eax),%eax
80100540:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100543:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100547:	75 22                	jne    8010056b <cprintf+0x151>
        s = "(null)";
80100549:	c7 45 ec b3 89 10 80 	movl   $0x801089b3,-0x14(%ebp)
      for(; *s; s++)
80100550:	eb 19                	jmp    8010056b <cprintf+0x151>
        consputc(*s);
80100552:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f be c0             	movsbl %al,%eax
8010055b:	83 ec 0c             	sub    $0xc,%esp
8010055e:	50                   	push   %eax
8010055f:	e8 aa 02 00 00       	call   8010080e <consputc>
80100564:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
80100567:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010056b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010056e:	0f b6 00             	movzbl (%eax),%eax
80100571:	84 c0                	test   %al,%al
80100573:	75 dd                	jne    80100552 <cprintf+0x138>
      break;
80100575:	eb 2b                	jmp    801005a2 <cprintf+0x188>
    case '%':
      consputc('%');
80100577:	83 ec 0c             	sub    $0xc,%esp
8010057a:	6a 25                	push   $0x25
8010057c:	e8 8d 02 00 00       	call   8010080e <consputc>
80100581:	83 c4 10             	add    $0x10,%esp
      break;
80100584:	eb 1c                	jmp    801005a2 <cprintf+0x188>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	6a 25                	push   $0x25
8010058b:	e8 7e 02 00 00       	call   8010080e <consputc>
80100590:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100593:	83 ec 0c             	sub    $0xc,%esp
80100596:	ff 75 e4             	pushl  -0x1c(%ebp)
80100599:	e8 70 02 00 00       	call   8010080e <consputc>
8010059e:	83 c4 10             	add    $0x10,%esp
      break;
801005a1:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005a6:	8b 55 08             	mov    0x8(%ebp),%edx
801005a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005ac:	01 d0                	add    %edx,%eax
801005ae:	0f b6 00             	movzbl (%eax),%eax
801005b1:	0f be c0             	movsbl %al,%eax
801005b4:	25 ff 00 00 00       	and    $0xff,%eax
801005b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801005bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801005c0:	0f 85 9e fe ff ff    	jne    80100464 <cprintf+0x4a>
801005c6:	eb 01                	jmp    801005c9 <cprintf+0x1af>
      break;
801005c8:	90                   	nop
    }
  }

  if(locking)
801005c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801005cd:	74 10                	je     801005df <cprintf+0x1c5>
    release(&cons.lock);
801005cf:	83 ec 0c             	sub    $0xc,%esp
801005d2:	68 e0 c5 10 80       	push   $0x8010c5e0
801005d7:	e8 39 4c 00 00       	call   80105215 <release>
801005dc:	83 c4 10             	add    $0x10,%esp
}
801005df:	90                   	nop
801005e0:	c9                   	leave  
801005e1:	c3                   	ret    

801005e2 <panic>:

void
panic(char *s)
{
801005e2:	55                   	push   %ebp
801005e3:	89 e5                	mov    %esp,%ebp
801005e5:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
801005e8:	e8 23 fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
801005ed:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
801005f4:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
801005f7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801005fd:	0f b6 00             	movzbl (%eax),%eax
80100600:	0f b6 c0             	movzbl %al,%eax
80100603:	83 ec 08             	sub    $0x8,%esp
80100606:	50                   	push   %eax
80100607:	68 ba 89 10 80       	push   $0x801089ba
8010060c:	e8 09 fe ff ff       	call   8010041a <cprintf>
80100611:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100614:	8b 45 08             	mov    0x8(%ebp),%eax
80100617:	83 ec 0c             	sub    $0xc,%esp
8010061a:	50                   	push   %eax
8010061b:	e8 fa fd ff ff       	call   8010041a <cprintf>
80100620:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80100623:	83 ec 0c             	sub    $0xc,%esp
80100626:	68 c9 89 10 80       	push   $0x801089c9
8010062b:	e8 ea fd ff ff       	call   8010041a <cprintf>
80100630:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
80100633:	83 ec 08             	sub    $0x8,%esp
80100636:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100639:	50                   	push   %eax
8010063a:	8d 45 08             	lea    0x8(%ebp),%eax
8010063d:	50                   	push   %eax
8010063e:	e8 24 4c 00 00       	call   80105267 <getcallerpcs>
80100643:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100646:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010064d:	eb 1c                	jmp    8010066b <panic+0x89>
    cprintf(" %p", pcs[i]);
8010064f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100652:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100656:	83 ec 08             	sub    $0x8,%esp
80100659:	50                   	push   %eax
8010065a:	68 cb 89 10 80       	push   $0x801089cb
8010065f:	e8 b6 fd ff ff       	call   8010041a <cprintf>
80100664:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100667:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010066b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010066f:	7e de                	jle    8010064f <panic+0x6d>
  panicked = 1; // freeze other CPU
80100671:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
80100678:	00 00 00 
  for(;;)
8010067b:	eb fe                	jmp    8010067b <panic+0x99>

8010067d <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
8010067d:	55                   	push   %ebp
8010067e:	89 e5                	mov    %esp,%ebp
80100680:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100683:	6a 0e                	push   $0xe
80100685:	68 d4 03 00 00       	push   $0x3d4
8010068a:	e8 62 fc ff ff       	call   801002f1 <outb>
8010068f:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100692:	68 d5 03 00 00       	push   $0x3d5
80100697:	e8 38 fc ff ff       	call   801002d4 <inb>
8010069c:	83 c4 04             	add    $0x4,%esp
8010069f:	0f b6 c0             	movzbl %al,%eax
801006a2:	c1 e0 08             	shl    $0x8,%eax
801006a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801006a8:	6a 0f                	push   $0xf
801006aa:	68 d4 03 00 00       	push   $0x3d4
801006af:	e8 3d fc ff ff       	call   801002f1 <outb>
801006b4:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
801006b7:	68 d5 03 00 00       	push   $0x3d5
801006bc:	e8 13 fc ff ff       	call   801002d4 <inb>
801006c1:	83 c4 04             	add    $0x4,%esp
801006c4:	0f b6 c0             	movzbl %al,%eax
801006c7:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
801006ca:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
801006ce:	75 30                	jne    80100700 <cgaputc+0x83>
    pos += 80 - pos%80;
801006d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006d3:	ba 67 66 66 66       	mov    $0x66666667,%edx
801006d8:	89 c8                	mov    %ecx,%eax
801006da:	f7 ea                	imul   %edx
801006dc:	c1 fa 05             	sar    $0x5,%edx
801006df:	89 c8                	mov    %ecx,%eax
801006e1:	c1 f8 1f             	sar    $0x1f,%eax
801006e4:	29 c2                	sub    %eax,%edx
801006e6:	89 d0                	mov    %edx,%eax
801006e8:	c1 e0 02             	shl    $0x2,%eax
801006eb:	01 d0                	add    %edx,%eax
801006ed:	c1 e0 04             	shl    $0x4,%eax
801006f0:	29 c1                	sub    %eax,%ecx
801006f2:	89 ca                	mov    %ecx,%edx
801006f4:	b8 50 00 00 00       	mov    $0x50,%eax
801006f9:	29 d0                	sub    %edx,%eax
801006fb:	01 45 f4             	add    %eax,-0xc(%ebp)
801006fe:	eb 34                	jmp    80100734 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100700:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100707:	75 0c                	jne    80100715 <cgaputc+0x98>
    if(pos > 0) --pos;
80100709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010070d:	7e 25                	jle    80100734 <cgaputc+0xb7>
8010070f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100713:	eb 1f                	jmp    80100734 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100715:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010071b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010071e:	8d 50 01             	lea    0x1(%eax),%edx
80100721:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100724:	01 c0                	add    %eax,%eax
80100726:	01 c8                	add    %ecx,%eax
80100728:	8b 55 08             	mov    0x8(%ebp),%edx
8010072b:	0f b6 d2             	movzbl %dl,%edx
8010072e:	80 ce 07             	or     $0x7,%dh
80100731:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
80100734:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100738:	78 09                	js     80100743 <cgaputc+0xc6>
8010073a:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
80100741:	7e 0d                	jle    80100750 <cgaputc+0xd3>
    panic("pos under/overflow");
80100743:	83 ec 0c             	sub    $0xc,%esp
80100746:	68 cf 89 10 80       	push   $0x801089cf
8010074b:	e8 92 fe ff ff       	call   801005e2 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
80100750:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100757:	7e 4c                	jle    801007a5 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100759:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010075e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100764:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100769:	83 ec 04             	sub    $0x4,%esp
8010076c:	68 60 0e 00 00       	push   $0xe60
80100771:	52                   	push   %edx
80100772:	50                   	push   %eax
80100773:	e8 58 4d 00 00       	call   801054d0 <memmove>
80100778:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
8010077b:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010077f:	b8 80 07 00 00       	mov    $0x780,%eax
80100784:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100787:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010078a:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010078f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100792:	01 c9                	add    %ecx,%ecx
80100794:	01 c8                	add    %ecx,%eax
80100796:	83 ec 04             	sub    $0x4,%esp
80100799:	52                   	push   %edx
8010079a:	6a 00                	push   $0x0
8010079c:	50                   	push   %eax
8010079d:	e8 6f 4c 00 00       	call   80105411 <memset>
801007a2:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
801007a5:	83 ec 08             	sub    $0x8,%esp
801007a8:	6a 0e                	push   $0xe
801007aa:	68 d4 03 00 00       	push   $0x3d4
801007af:	e8 3d fb ff ff       	call   801002f1 <outb>
801007b4:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
801007b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007ba:	c1 f8 08             	sar    $0x8,%eax
801007bd:	0f b6 c0             	movzbl %al,%eax
801007c0:	83 ec 08             	sub    $0x8,%esp
801007c3:	50                   	push   %eax
801007c4:	68 d5 03 00 00       	push   $0x3d5
801007c9:	e8 23 fb ff ff       	call   801002f1 <outb>
801007ce:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
801007d1:	83 ec 08             	sub    $0x8,%esp
801007d4:	6a 0f                	push   $0xf
801007d6:	68 d4 03 00 00       	push   $0x3d4
801007db:	e8 11 fb ff ff       	call   801002f1 <outb>
801007e0:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
801007e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007e6:	0f b6 c0             	movzbl %al,%eax
801007e9:	83 ec 08             	sub    $0x8,%esp
801007ec:	50                   	push   %eax
801007ed:	68 d5 03 00 00       	push   $0x3d5
801007f2:	e8 fa fa ff ff       	call   801002f1 <outb>
801007f7:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007fa:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801007ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100802:	01 d2                	add    %edx,%edx
80100804:	01 d0                	add    %edx,%eax
80100806:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010080b:	90                   	nop
8010080c:	c9                   	leave  
8010080d:	c3                   	ret    

8010080e <consputc>:

void
consputc(int c)
{
8010080e:	55                   	push   %ebp
8010080f:	89 e5                	mov    %esp,%ebp
80100811:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100814:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
80100819:	85 c0                	test   %eax,%eax
8010081b:	74 07                	je     80100824 <consputc+0x16>
    cli();
8010081d:	e8 ee fa ff ff       	call   80100310 <cli>
    for(;;)
80100822:	eb fe                	jmp    80100822 <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
80100824:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010082b:	75 29                	jne    80100856 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010082d:	83 ec 0c             	sub    $0xc,%esp
80100830:	6a 08                	push   $0x8
80100832:	e8 91 65 00 00       	call   80106dc8 <uartputc>
80100837:	83 c4 10             	add    $0x10,%esp
8010083a:	83 ec 0c             	sub    $0xc,%esp
8010083d:	6a 20                	push   $0x20
8010083f:	e8 84 65 00 00       	call   80106dc8 <uartputc>
80100844:	83 c4 10             	add    $0x10,%esp
80100847:	83 ec 0c             	sub    $0xc,%esp
8010084a:	6a 08                	push   $0x8
8010084c:	e8 77 65 00 00       	call   80106dc8 <uartputc>
80100851:	83 c4 10             	add    $0x10,%esp
80100854:	eb 0e                	jmp    80100864 <consputc+0x56>
  } else
    uartputc(c);
80100856:	83 ec 0c             	sub    $0xc,%esp
80100859:	ff 75 08             	pushl  0x8(%ebp)
8010085c:	e8 67 65 00 00       	call   80106dc8 <uartputc>
80100861:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100864:	83 ec 0c             	sub    $0xc,%esp
80100867:	ff 75 08             	pushl  0x8(%ebp)
8010086a:	e8 0e fe ff ff       	call   8010067d <cgaputc>
8010086f:	83 c4 10             	add    $0x10,%esp
}
80100872:	90                   	nop
80100873:	c9                   	leave  
80100874:	c3                   	ret    

80100875 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100875:	55                   	push   %ebp
80100876:	89 e5                	mov    %esp,%ebp
80100878:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
8010087b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100882:	83 ec 0c             	sub    $0xc,%esp
80100885:	68 e0 c5 10 80       	push   $0x8010c5e0
8010088a:	e8 1f 49 00 00       	call   801051ae <acquire>
8010088f:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100892:	e9 44 01 00 00       	jmp    801009db <consoleintr+0x166>
    switch(c){
80100897:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010089a:	83 f8 10             	cmp    $0x10,%eax
8010089d:	74 1e                	je     801008bd <consoleintr+0x48>
8010089f:	83 f8 10             	cmp    $0x10,%eax
801008a2:	7f 0a                	jg     801008ae <consoleintr+0x39>
801008a4:	83 f8 08             	cmp    $0x8,%eax
801008a7:	74 6b                	je     80100914 <consoleintr+0x9f>
801008a9:	e9 9b 00 00 00       	jmp    80100949 <consoleintr+0xd4>
801008ae:	83 f8 15             	cmp    $0x15,%eax
801008b1:	74 33                	je     801008e6 <consoleintr+0x71>
801008b3:	83 f8 7f             	cmp    $0x7f,%eax
801008b6:	74 5c                	je     80100914 <consoleintr+0x9f>
801008b8:	e9 8c 00 00 00       	jmp    80100949 <consoleintr+0xd4>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
801008bd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
801008c4:	e9 12 01 00 00       	jmp    801009db <consoleintr+0x166>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008c9:	a1 e8 21 11 80       	mov    0x801121e8,%eax
801008ce:	83 e8 01             	sub    $0x1,%eax
801008d1:	a3 e8 21 11 80       	mov    %eax,0x801121e8
        consputc(BACKSPACE);
801008d6:	83 ec 0c             	sub    $0xc,%esp
801008d9:	68 00 01 00 00       	push   $0x100
801008de:	e8 2b ff ff ff       	call   8010080e <consputc>
801008e3:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
801008e6:	8b 15 e8 21 11 80    	mov    0x801121e8,%edx
801008ec:	a1 e4 21 11 80       	mov    0x801121e4,%eax
801008f1:	39 c2                	cmp    %eax,%edx
801008f3:	0f 84 e2 00 00 00    	je     801009db <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f9:	a1 e8 21 11 80       	mov    0x801121e8,%eax
801008fe:	83 e8 01             	sub    $0x1,%eax
80100901:	83 e0 7f             	and    $0x7f,%eax
80100904:	0f b6 80 60 21 11 80 	movzbl -0x7feedea0(%eax),%eax
      while(input.e != input.w &&
8010090b:	3c 0a                	cmp    $0xa,%al
8010090d:	75 ba                	jne    801008c9 <consoleintr+0x54>
      }
      break;
8010090f:	e9 c7 00 00 00       	jmp    801009db <consoleintr+0x166>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100914:	8b 15 e8 21 11 80    	mov    0x801121e8,%edx
8010091a:	a1 e4 21 11 80       	mov    0x801121e4,%eax
8010091f:	39 c2                	cmp    %eax,%edx
80100921:	0f 84 b4 00 00 00    	je     801009db <consoleintr+0x166>
        input.e--;
80100927:	a1 e8 21 11 80       	mov    0x801121e8,%eax
8010092c:	83 e8 01             	sub    $0x1,%eax
8010092f:	a3 e8 21 11 80       	mov    %eax,0x801121e8
        consputc(BACKSPACE);
80100934:	83 ec 0c             	sub    $0xc,%esp
80100937:	68 00 01 00 00       	push   $0x100
8010093c:	e8 cd fe ff ff       	call   8010080e <consputc>
80100941:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100944:	e9 92 00 00 00       	jmp    801009db <consoleintr+0x166>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100949:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010094d:	0f 84 87 00 00 00    	je     801009da <consoleintr+0x165>
80100953:	8b 15 e8 21 11 80    	mov    0x801121e8,%edx
80100959:	a1 e0 21 11 80       	mov    0x801121e0,%eax
8010095e:	29 c2                	sub    %eax,%edx
80100960:	89 d0                	mov    %edx,%eax
80100962:	83 f8 7f             	cmp    $0x7f,%eax
80100965:	77 73                	ja     801009da <consoleintr+0x165>
        c = (c == '\r') ? '\n' : c;
80100967:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010096b:	74 05                	je     80100972 <consoleintr+0xfd>
8010096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100970:	eb 05                	jmp    80100977 <consoleintr+0x102>
80100972:	b8 0a 00 00 00       	mov    $0xa,%eax
80100977:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010097a:	a1 e8 21 11 80       	mov    0x801121e8,%eax
8010097f:	8d 50 01             	lea    0x1(%eax),%edx
80100982:	89 15 e8 21 11 80    	mov    %edx,0x801121e8
80100988:	83 e0 7f             	and    $0x7f,%eax
8010098b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010098e:	88 90 60 21 11 80    	mov    %dl,-0x7feedea0(%eax)
        consputc(c);
80100994:	83 ec 0c             	sub    $0xc,%esp
80100997:	ff 75 f0             	pushl  -0x10(%ebp)
8010099a:	e8 6f fe ff ff       	call   8010080e <consputc>
8010099f:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009a2:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009a6:	74 18                	je     801009c0 <consoleintr+0x14b>
801009a8:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009ac:	74 12                	je     801009c0 <consoleintr+0x14b>
801009ae:	a1 e8 21 11 80       	mov    0x801121e8,%eax
801009b3:	8b 15 e0 21 11 80    	mov    0x801121e0,%edx
801009b9:	83 ea 80             	sub    $0xffffff80,%edx
801009bc:	39 d0                	cmp    %edx,%eax
801009be:	75 1a                	jne    801009da <consoleintr+0x165>
          input.w = input.e;
801009c0:	a1 e8 21 11 80       	mov    0x801121e8,%eax
801009c5:	a3 e4 21 11 80       	mov    %eax,0x801121e4
          wakeup(&input.r);
801009ca:	83 ec 0c             	sub    $0xc,%esp
801009cd:	68 e0 21 11 80       	push   $0x801121e0
801009d2:	e8 c9 45 00 00       	call   80104fa0 <wakeup>
801009d7:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009da:	90                   	nop
  while((c = getc()) >= 0){
801009db:	8b 45 08             	mov    0x8(%ebp),%eax
801009de:	ff d0                	call   *%eax
801009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801009e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009e7:	0f 89 aa fe ff ff    	jns    80100897 <consoleintr+0x22>
    }
  }
  release(&cons.lock);
801009ed:	83 ec 0c             	sub    $0xc,%esp
801009f0:	68 e0 c5 10 80       	push   $0x8010c5e0
801009f5:	e8 1b 48 00 00       	call   80105215 <release>
801009fa:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a01:	74 05                	je     80100a08 <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
80100a03:	e8 53 46 00 00       	call   8010505b <procdump>
  }
}
80100a08:	90                   	nop
80100a09:	c9                   	leave  
80100a0a:	c3                   	ret    

80100a0b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a0b:	55                   	push   %ebp
80100a0c:	89 e5                	mov    %esp,%ebp
80100a0e:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a11:	83 ec 0c             	sub    $0xc,%esp
80100a14:	ff 75 08             	pushl  0x8(%ebp)
80100a17:	e8 28 11 00 00       	call   80101b44 <iunlock>
80100a1c:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a1f:	8b 45 10             	mov    0x10(%ebp),%eax
80100a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a25:	83 ec 0c             	sub    $0xc,%esp
80100a28:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a2d:	e8 7c 47 00 00       	call   801051ae <acquire>
80100a32:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a35:	e9 ac 00 00 00       	jmp    80100ae6 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a40:	8b 40 24             	mov    0x24(%eax),%eax
80100a43:	85 c0                	test   %eax,%eax
80100a45:	74 28                	je     80100a6f <consoleread+0x64>
        release(&cons.lock);
80100a47:	83 ec 0c             	sub    $0xc,%esp
80100a4a:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a4f:	e8 c1 47 00 00       	call   80105215 <release>
80100a54:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a57:	83 ec 0c             	sub    $0xc,%esp
80100a5a:	ff 75 08             	pushl  0x8(%ebp)
80100a5d:	e8 84 0f 00 00       	call   801019e6 <ilock>
80100a62:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a6a:	e9 ab 00 00 00       	jmp    80100b1a <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a6f:	83 ec 08             	sub    $0x8,%esp
80100a72:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a77:	68 e0 21 11 80       	push   $0x801121e0
80100a7c:	e8 34 44 00 00       	call   80104eb5 <sleep>
80100a81:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a84:	8b 15 e0 21 11 80    	mov    0x801121e0,%edx
80100a8a:	a1 e4 21 11 80       	mov    0x801121e4,%eax
80100a8f:	39 c2                	cmp    %eax,%edx
80100a91:	74 a7                	je     80100a3a <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a93:	a1 e0 21 11 80       	mov    0x801121e0,%eax
80100a98:	8d 50 01             	lea    0x1(%eax),%edx
80100a9b:	89 15 e0 21 11 80    	mov    %edx,0x801121e0
80100aa1:	83 e0 7f             	and    $0x7f,%eax
80100aa4:	0f b6 80 60 21 11 80 	movzbl -0x7feedea0(%eax),%eax
80100aab:	0f be c0             	movsbl %al,%eax
80100aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100ab1:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100ab5:	75 17                	jne    80100ace <consoleread+0xc3>
      if(n < target){
80100ab7:	8b 45 10             	mov    0x10(%ebp),%eax
80100aba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100abd:	73 2f                	jae    80100aee <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100abf:	a1 e0 21 11 80       	mov    0x801121e0,%eax
80100ac4:	83 e8 01             	sub    $0x1,%eax
80100ac7:	a3 e0 21 11 80       	mov    %eax,0x801121e0
      }
      break;
80100acc:	eb 20                	jmp    80100aee <consoleread+0xe3>
    }
    *dst++ = c;
80100ace:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad1:	8d 50 01             	lea    0x1(%eax),%edx
80100ad4:	89 55 0c             	mov    %edx,0xc(%ebp)
80100ad7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100ada:	88 10                	mov    %dl,(%eax)
    --n;
80100adc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100ae0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100ae4:	74 0b                	je     80100af1 <consoleread+0xe6>
  while(n > 0){
80100ae6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100aea:	7f 98                	jg     80100a84 <consoleread+0x79>
80100aec:	eb 04                	jmp    80100af2 <consoleread+0xe7>
      break;
80100aee:	90                   	nop
80100aef:	eb 01                	jmp    80100af2 <consoleread+0xe7>
      break;
80100af1:	90                   	nop
  }
  release(&cons.lock);
80100af2:	83 ec 0c             	sub    $0xc,%esp
80100af5:	68 e0 c5 10 80       	push   $0x8010c5e0
80100afa:	e8 16 47 00 00       	call   80105215 <release>
80100aff:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b02:	83 ec 0c             	sub    $0xc,%esp
80100b05:	ff 75 08             	pushl  0x8(%ebp)
80100b08:	e8 d9 0e 00 00       	call   801019e6 <ilock>
80100b0d:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b10:	8b 45 10             	mov    0x10(%ebp),%eax
80100b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b16:	29 c2                	sub    %eax,%edx
80100b18:	89 d0                	mov    %edx,%eax
}
80100b1a:	c9                   	leave  
80100b1b:	c3                   	ret    

80100b1c <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b1c:	55                   	push   %ebp
80100b1d:	89 e5                	mov    %esp,%ebp
80100b1f:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b22:	83 ec 0c             	sub    $0xc,%esp
80100b25:	ff 75 08             	pushl  0x8(%ebp)
80100b28:	e8 17 10 00 00       	call   80101b44 <iunlock>
80100b2d:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b30:	83 ec 0c             	sub    $0xc,%esp
80100b33:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b38:	e8 71 46 00 00       	call   801051ae <acquire>
80100b3d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b47:	eb 21                	jmp    80100b6a <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b4f:	01 d0                	add    %edx,%eax
80100b51:	0f b6 00             	movzbl (%eax),%eax
80100b54:	0f be c0             	movsbl %al,%eax
80100b57:	0f b6 c0             	movzbl %al,%eax
80100b5a:	83 ec 0c             	sub    $0xc,%esp
80100b5d:	50                   	push   %eax
80100b5e:	e8 ab fc ff ff       	call   8010080e <consputc>
80100b63:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b66:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b6d:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b70:	7c d7                	jl     80100b49 <consolewrite+0x2d>
  release(&cons.lock);
80100b72:	83 ec 0c             	sub    $0xc,%esp
80100b75:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b7a:	e8 96 46 00 00       	call   80105215 <release>
80100b7f:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b82:	83 ec 0c             	sub    $0xc,%esp
80100b85:	ff 75 08             	pushl  0x8(%ebp)
80100b88:	e8 59 0e 00 00       	call   801019e6 <ilock>
80100b8d:	83 c4 10             	add    $0x10,%esp

  return n;
80100b90:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b93:	c9                   	leave  
80100b94:	c3                   	ret    

80100b95 <consoleinit>:

void
consoleinit(void)
{
80100b95:	55                   	push   %ebp
80100b96:	89 e5                	mov    %esp,%ebp
80100b98:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b9b:	83 ec 08             	sub    $0x8,%esp
80100b9e:	68 e2 89 10 80       	push   $0x801089e2
80100ba3:	68 e0 c5 10 80       	push   $0x8010c5e0
80100ba8:	e8 df 45 00 00       	call   8010518c <initlock>
80100bad:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bb0:	c7 05 ac 2b 11 80 1c 	movl   $0x80100b1c,0x80112bac
80100bb7:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100bba:	c7 05 a8 2b 11 80 0b 	movl   $0x80100a0b,0x80112ba8
80100bc1:	0a 10 80 
  cons.locking = 1;
80100bc4:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100bcb:	00 00 00 

  picenable(IRQ_KBD);
80100bce:	83 ec 0c             	sub    $0xc,%esp
80100bd1:	6a 01                	push   $0x1
80100bd3:	e8 22 34 00 00       	call   80103ffa <picenable>
80100bd8:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100bdb:	83 ec 08             	sub    $0x8,%esp
80100bde:	6a 00                	push   $0x0
80100be0:	6a 01                	push   $0x1
80100be2:	e8 6f 1f 00 00       	call   80102b56 <ioapicenable>
80100be7:	83 c4 10             	add    $0x10,%esp
}
80100bea:	90                   	nop
80100beb:	c9                   	leave  
80100bec:	c3                   	ret    

80100bed <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bed:	55                   	push   %ebp
80100bee:	89 e5                	mov    %esp,%ebp
80100bf0:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100bf6:	e8 21 2a 00 00       	call   8010361c <begin_op>
  if((ip = namei(path)) == 0){
80100bfb:	83 ec 0c             	sub    $0xc,%esp
80100bfe:	ff 75 08             	pushl  0x8(%ebp)
80100c01:	e8 9e 19 00 00       	call   801025a4 <namei>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c0c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c10:	75 0f                	jne    80100c21 <exec+0x34>
    end_op();
80100c12:	e8 91 2a 00 00       	call   801036a8 <end_op>
    return -1;
80100c17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c1c:	e9 ce 03 00 00       	jmp    80100fef <exec+0x402>
  }
  ilock(ip);
80100c21:	83 ec 0c             	sub    $0xc,%esp
80100c24:	ff 75 d8             	pushl  -0x28(%ebp)
80100c27:	e8 ba 0d 00 00       	call   801019e6 <ilock>
80100c2c:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c2f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100c36:	6a 34                	push   $0x34
80100c38:	6a 00                	push   $0x0
80100c3a:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100c40:	50                   	push   %eax
80100c41:	ff 75 d8             	pushl  -0x28(%ebp)
80100c44:	e8 0b 13 00 00       	call   80101f54 <readi>
80100c49:	83 c4 10             	add    $0x10,%esp
80100c4c:	83 f8 33             	cmp    $0x33,%eax
80100c4f:	0f 86 49 03 00 00    	jbe    80100f9e <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c55:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c5b:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c60:	0f 85 3b 03 00 00    	jne    80100fa1 <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c66:	e8 f4 74 00 00       	call   8010815f <setupkvm>
80100c6b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c6e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c72:	0f 84 2c 03 00 00    	je     80100fa4 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c78:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c7f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c86:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c8f:	e9 ab 00 00 00       	jmp    80100d3f <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c94:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c97:	6a 20                	push   $0x20
80100c99:	50                   	push   %eax
80100c9a:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100ca0:	50                   	push   %eax
80100ca1:	ff 75 d8             	pushl  -0x28(%ebp)
80100ca4:	e8 ab 12 00 00       	call   80101f54 <readi>
80100ca9:	83 c4 10             	add    $0x10,%esp
80100cac:	83 f8 20             	cmp    $0x20,%eax
80100caf:	0f 85 f2 02 00 00    	jne    80100fa7 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100cb5:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100cbb:	83 f8 01             	cmp    $0x1,%eax
80100cbe:	75 71                	jne    80100d31 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100cc0:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100cc6:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100ccc:	39 c2                	cmp    %eax,%edx
80100cce:	0f 82 d6 02 00 00    	jb     80100faa <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cd4:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100cda:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100ce0:	01 d0                	add    %edx,%eax
80100ce2:	83 ec 04             	sub    $0x4,%esp
80100ce5:	50                   	push   %eax
80100ce6:	ff 75 e0             	pushl  -0x20(%ebp)
80100ce9:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cec:	e8 15 78 00 00       	call   80108506 <allocuvm>
80100cf1:	83 c4 10             	add    $0x10,%esp
80100cf4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cf7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cfb:	0f 84 ac 02 00 00    	je     80100fad <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d01:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d07:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d0d:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d13:	83 ec 0c             	sub    $0xc,%esp
80100d16:	52                   	push   %edx
80100d17:	50                   	push   %eax
80100d18:	ff 75 d8             	pushl  -0x28(%ebp)
80100d1b:	51                   	push   %ecx
80100d1c:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1f:	e8 0b 77 00 00       	call   8010842f <loaduvm>
80100d24:	83 c4 20             	add    $0x20,%esp
80100d27:	85 c0                	test   %eax,%eax
80100d29:	0f 88 81 02 00 00    	js     80100fb0 <exec+0x3c3>
80100d2f:	eb 01                	jmp    80100d32 <exec+0x145>
      continue;
80100d31:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d32:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d39:	83 c0 20             	add    $0x20,%eax
80100d3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d3f:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100d46:	0f b7 c0             	movzwl %ax,%eax
80100d49:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d4c:	0f 8f 42 ff ff ff    	jg     80100c94 <exec+0xa7>
      goto bad;
  }
  iunlockput(ip);
80100d52:	83 ec 0c             	sub    $0xc,%esp
80100d55:	ff 75 d8             	pushl  -0x28(%ebp)
80100d58:	e8 49 0f 00 00       	call   80101ca6 <iunlockput>
80100d5d:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d60:	e8 43 29 00 00       	call   801036a8 <end_op>
  ip = 0;
80100d65:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d6f:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d79:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d7f:	05 00 20 00 00       	add    $0x2000,%eax
80100d84:	83 ec 04             	sub    $0x4,%esp
80100d87:	50                   	push   %eax
80100d88:	ff 75 e0             	pushl  -0x20(%ebp)
80100d8b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d8e:	e8 73 77 00 00       	call   80108506 <allocuvm>
80100d93:	83 c4 10             	add    $0x10,%esp
80100d96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d99:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d9d:	0f 84 10 02 00 00    	je     80100fb3 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100da3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100dab:	83 ec 08             	sub    $0x8,%esp
80100dae:	50                   	push   %eax
80100daf:	ff 75 d4             	pushl  -0x2c(%ebp)
80100db2:	e8 75 79 00 00       	call   8010872c <clearpteu>
80100db7:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100dba:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dbd:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dc0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100dc7:	e9 96 00 00 00       	jmp    80100e62 <exec+0x275>
    if(argc >= MAXARG)
80100dcc:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dd0:	0f 87 e0 01 00 00    	ja     80100fb6 <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100de3:	01 d0                	add    %edx,%eax
80100de5:	8b 00                	mov    (%eax),%eax
80100de7:	83 ec 0c             	sub    $0xc,%esp
80100dea:	50                   	push   %eax
80100deb:	e8 6e 48 00 00       	call   8010565e <strlen>
80100df0:	83 c4 10             	add    $0x10,%esp
80100df3:	89 c2                	mov    %eax,%edx
80100df5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100df8:	29 d0                	sub    %edx,%eax
80100dfa:	83 e8 01             	sub    $0x1,%eax
80100dfd:	83 e0 fc             	and    $0xfffffffc,%eax
80100e00:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e10:	01 d0                	add    %edx,%eax
80100e12:	8b 00                	mov    (%eax),%eax
80100e14:	83 ec 0c             	sub    $0xc,%esp
80100e17:	50                   	push   %eax
80100e18:	e8 41 48 00 00       	call   8010565e <strlen>
80100e1d:	83 c4 10             	add    $0x10,%esp
80100e20:	83 c0 01             	add    $0x1,%eax
80100e23:	89 c1                	mov    %eax,%ecx
80100e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e32:	01 d0                	add    %edx,%eax
80100e34:	8b 00                	mov    (%eax),%eax
80100e36:	51                   	push   %ecx
80100e37:	50                   	push   %eax
80100e38:	ff 75 dc             	pushl  -0x24(%ebp)
80100e3b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e3e:	e8 a0 7a 00 00       	call   801088e3 <copyout>
80100e43:	83 c4 10             	add    $0x10,%esp
80100e46:	85 c0                	test   %eax,%eax
80100e48:	0f 88 6b 01 00 00    	js     80100fb9 <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e51:	8d 50 03             	lea    0x3(%eax),%edx
80100e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e57:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e5e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e65:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e6f:	01 d0                	add    %edx,%eax
80100e71:	8b 00                	mov    (%eax),%eax
80100e73:	85 c0                	test   %eax,%eax
80100e75:	0f 85 51 ff ff ff    	jne    80100dcc <exec+0x1df>
  }
  ustack[3+argc] = 0;
80100e7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e7e:	83 c0 03             	add    $0x3,%eax
80100e81:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e88:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e8c:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e93:	ff ff ff 
  ustack[1] = argc;
80100e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e99:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea2:	83 c0 01             	add    $0x1,%eax
80100ea5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100eac:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100eaf:	29 d0                	sub    %edx,%eax
80100eb1:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eba:	83 c0 04             	add    $0x4,%eax
80100ebd:	c1 e0 02             	shl    $0x2,%eax
80100ec0:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ec3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec6:	83 c0 04             	add    $0x4,%eax
80100ec9:	c1 e0 02             	shl    $0x2,%eax
80100ecc:	50                   	push   %eax
80100ecd:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100ed3:	50                   	push   %eax
80100ed4:	ff 75 dc             	pushl  -0x24(%ebp)
80100ed7:	ff 75 d4             	pushl  -0x2c(%ebp)
80100eda:	e8 04 7a 00 00       	call   801088e3 <copyout>
80100edf:	83 c4 10             	add    $0x10,%esp
80100ee2:	85 c0                	test   %eax,%eax
80100ee4:	0f 88 d2 00 00 00    	js     80100fbc <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100eea:	8b 45 08             	mov    0x8(%ebp),%eax
80100eed:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ef3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ef6:	eb 17                	jmp    80100f0f <exec+0x322>
    if(*s == '/')
80100ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100efb:	0f b6 00             	movzbl (%eax),%eax
80100efe:	3c 2f                	cmp    $0x2f,%al
80100f00:	75 09                	jne    80100f0b <exec+0x31e>
      last = s+1;
80100f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f05:	83 c0 01             	add    $0x1,%eax
80100f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100f0b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f12:	0f b6 00             	movzbl (%eax),%eax
80100f15:	84 c0                	test   %al,%al
80100f17:	75 df                	jne    80100ef8 <exec+0x30b>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f1f:	83 c0 6c             	add    $0x6c,%eax
80100f22:	83 ec 04             	sub    $0x4,%esp
80100f25:	6a 10                	push   $0x10
80100f27:	ff 75 f0             	pushl  -0x10(%ebp)
80100f2a:	50                   	push   %eax
80100f2b:	e8 e4 46 00 00       	call   80105614 <safestrcpy>
80100f30:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f39:	8b 40 04             	mov    0x4(%eax),%eax
80100f3c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100f3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f45:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f48:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f51:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f54:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f5c:	8b 40 18             	mov    0x18(%eax),%eax
80100f5f:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f65:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f6e:	8b 40 18             	mov    0x18(%eax),%eax
80100f71:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f74:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	50                   	push   %eax
80100f81:	e8 c0 72 00 00       	call   80108246 <switchuvm>
80100f86:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	ff 75 d0             	pushl  -0x30(%ebp)
80100f8f:	e8 f8 76 00 00       	call   8010868c <freevm>
80100f94:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f97:	b8 00 00 00 00       	mov    $0x0,%eax
80100f9c:	eb 51                	jmp    80100fef <exec+0x402>
    goto bad;
80100f9e:	90                   	nop
80100f9f:	eb 1c                	jmp    80100fbd <exec+0x3d0>
    goto bad;
80100fa1:	90                   	nop
80100fa2:	eb 19                	jmp    80100fbd <exec+0x3d0>
    goto bad;
80100fa4:	90                   	nop
80100fa5:	eb 16                	jmp    80100fbd <exec+0x3d0>
      goto bad;
80100fa7:	90                   	nop
80100fa8:	eb 13                	jmp    80100fbd <exec+0x3d0>
      goto bad;
80100faa:	90                   	nop
80100fab:	eb 10                	jmp    80100fbd <exec+0x3d0>
      goto bad;
80100fad:	90                   	nop
80100fae:	eb 0d                	jmp    80100fbd <exec+0x3d0>
      goto bad;
80100fb0:	90                   	nop
80100fb1:	eb 0a                	jmp    80100fbd <exec+0x3d0>
    goto bad;
80100fb3:	90                   	nop
80100fb4:	eb 07                	jmp    80100fbd <exec+0x3d0>
      goto bad;
80100fb6:	90                   	nop
80100fb7:	eb 04                	jmp    80100fbd <exec+0x3d0>
      goto bad;
80100fb9:	90                   	nop
80100fba:	eb 01                	jmp    80100fbd <exec+0x3d0>
    goto bad;
80100fbc:	90                   	nop

 bad:
  if(pgdir)
80100fbd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fc1:	74 0e                	je     80100fd1 <exec+0x3e4>
    freevm(pgdir);
80100fc3:	83 ec 0c             	sub    $0xc,%esp
80100fc6:	ff 75 d4             	pushl  -0x2c(%ebp)
80100fc9:	e8 be 76 00 00       	call   8010868c <freevm>
80100fce:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fd1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fd5:	74 13                	je     80100fea <exec+0x3fd>
    iunlockput(ip);
80100fd7:	83 ec 0c             	sub    $0xc,%esp
80100fda:	ff 75 d8             	pushl  -0x28(%ebp)
80100fdd:	e8 c4 0c 00 00       	call   80101ca6 <iunlockput>
80100fe2:	83 c4 10             	add    $0x10,%esp
    end_op();
80100fe5:	e8 be 26 00 00       	call   801036a8 <end_op>
  }
  return -1;
80100fea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fef:	c9                   	leave  
80100ff0:	c3                   	ret    

80100ff1 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100ff1:	55                   	push   %ebp
80100ff2:	89 e5                	mov    %esp,%ebp
80100ff4:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100ff7:	83 ec 08             	sub    $0x8,%esp
80100ffa:	68 ea 89 10 80       	push   $0x801089ea
80100fff:	68 00 22 11 80       	push   $0x80112200
80101004:	e8 83 41 00 00       	call   8010518c <initlock>
80101009:	83 c4 10             	add    $0x10,%esp
}
8010100c:	90                   	nop
8010100d:	c9                   	leave  
8010100e:	c3                   	ret    

8010100f <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
8010100f:	55                   	push   %ebp
80101010:	89 e5                	mov    %esp,%ebp
80101012:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80101015:	83 ec 0c             	sub    $0xc,%esp
80101018:	68 00 22 11 80       	push   $0x80112200
8010101d:	e8 8c 41 00 00       	call   801051ae <acquire>
80101022:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101025:	c7 45 f4 34 22 11 80 	movl   $0x80112234,-0xc(%ebp)
8010102c:	eb 2d                	jmp    8010105b <filealloc+0x4c>
    if(f->ref == 0){
8010102e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101031:	8b 40 04             	mov    0x4(%eax),%eax
80101034:	85 c0                	test   %eax,%eax
80101036:	75 1f                	jne    80101057 <filealloc+0x48>
      f->ref = 1;
80101038:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010103b:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101042:	83 ec 0c             	sub    $0xc,%esp
80101045:	68 00 22 11 80       	push   $0x80112200
8010104a:	e8 c6 41 00 00       	call   80105215 <release>
8010104f:	83 c4 10             	add    $0x10,%esp
      return f;
80101052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101055:	eb 23                	jmp    8010107a <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101057:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010105b:	b8 94 2b 11 80       	mov    $0x80112b94,%eax
80101060:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101063:	72 c9                	jb     8010102e <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
80101065:	83 ec 0c             	sub    $0xc,%esp
80101068:	68 00 22 11 80       	push   $0x80112200
8010106d:	e8 a3 41 00 00       	call   80105215 <release>
80101072:	83 c4 10             	add    $0x10,%esp
  return 0;
80101075:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010107a:	c9                   	leave  
8010107b:	c3                   	ret    

8010107c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010107c:	55                   	push   %ebp
8010107d:	89 e5                	mov    %esp,%ebp
8010107f:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101082:	83 ec 0c             	sub    $0xc,%esp
80101085:	68 00 22 11 80       	push   $0x80112200
8010108a:	e8 1f 41 00 00       	call   801051ae <acquire>
8010108f:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101092:	8b 45 08             	mov    0x8(%ebp),%eax
80101095:	8b 40 04             	mov    0x4(%eax),%eax
80101098:	85 c0                	test   %eax,%eax
8010109a:	7f 0d                	jg     801010a9 <filedup+0x2d>
    panic("filedup");
8010109c:	83 ec 0c             	sub    $0xc,%esp
8010109f:	68 f1 89 10 80       	push   $0x801089f1
801010a4:	e8 39 f5 ff ff       	call   801005e2 <panic>
  f->ref++;
801010a9:	8b 45 08             	mov    0x8(%ebp),%eax
801010ac:	8b 40 04             	mov    0x4(%eax),%eax
801010af:	8d 50 01             	lea    0x1(%eax),%edx
801010b2:	8b 45 08             	mov    0x8(%ebp),%eax
801010b5:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	68 00 22 11 80       	push   $0x80112200
801010c0:	e8 50 41 00 00       	call   80105215 <release>
801010c5:	83 c4 10             	add    $0x10,%esp
  return f;
801010c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010cb:	c9                   	leave  
801010cc:	c3                   	ret    

801010cd <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010cd:	55                   	push   %ebp
801010ce:	89 e5                	mov    %esp,%ebp
801010d0:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010d3:	83 ec 0c             	sub    $0xc,%esp
801010d6:	68 00 22 11 80       	push   $0x80112200
801010db:	e8 ce 40 00 00       	call   801051ae <acquire>
801010e0:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010e3:	8b 45 08             	mov    0x8(%ebp),%eax
801010e6:	8b 40 04             	mov    0x4(%eax),%eax
801010e9:	85 c0                	test   %eax,%eax
801010eb:	7f 0d                	jg     801010fa <fileclose+0x2d>
    panic("fileclose");
801010ed:	83 ec 0c             	sub    $0xc,%esp
801010f0:	68 f9 89 10 80       	push   $0x801089f9
801010f5:	e8 e8 f4 ff ff       	call   801005e2 <panic>
  if(--f->ref > 0){
801010fa:	8b 45 08             	mov    0x8(%ebp),%eax
801010fd:	8b 40 04             	mov    0x4(%eax),%eax
80101100:	8d 50 ff             	lea    -0x1(%eax),%edx
80101103:	8b 45 08             	mov    0x8(%ebp),%eax
80101106:	89 50 04             	mov    %edx,0x4(%eax)
80101109:	8b 45 08             	mov    0x8(%ebp),%eax
8010110c:	8b 40 04             	mov    0x4(%eax),%eax
8010110f:	85 c0                	test   %eax,%eax
80101111:	7e 15                	jle    80101128 <fileclose+0x5b>
    release(&ftable.lock);
80101113:	83 ec 0c             	sub    $0xc,%esp
80101116:	68 00 22 11 80       	push   $0x80112200
8010111b:	e8 f5 40 00 00       	call   80105215 <release>
80101120:	83 c4 10             	add    $0x10,%esp
80101123:	e9 8b 00 00 00       	jmp    801011b3 <fileclose+0xe6>
    return;
  }
  ff = *f;
80101128:	8b 45 08             	mov    0x8(%ebp),%eax
8010112b:	8b 10                	mov    (%eax),%edx
8010112d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101130:	8b 50 04             	mov    0x4(%eax),%edx
80101133:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101136:	8b 50 08             	mov    0x8(%eax),%edx
80101139:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010113c:	8b 50 0c             	mov    0xc(%eax),%edx
8010113f:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101142:	8b 50 10             	mov    0x10(%eax),%edx
80101145:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101148:	8b 40 14             	mov    0x14(%eax),%eax
8010114b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010114e:	8b 45 08             	mov    0x8(%ebp),%eax
80101151:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101158:	8b 45 08             	mov    0x8(%ebp),%eax
8010115b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101161:	83 ec 0c             	sub    $0xc,%esp
80101164:	68 00 22 11 80       	push   $0x80112200
80101169:	e8 a7 40 00 00       	call   80105215 <release>
8010116e:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101171:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101174:	83 f8 01             	cmp    $0x1,%eax
80101177:	75 19                	jne    80101192 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101179:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010117d:	0f be d0             	movsbl %al,%edx
80101180:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101183:	83 ec 08             	sub    $0x8,%esp
80101186:	52                   	push   %edx
80101187:	50                   	push   %eax
80101188:	e8 d6 30 00 00       	call   80104263 <pipeclose>
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	eb 21                	jmp    801011b3 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101192:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101195:	83 f8 02             	cmp    $0x2,%eax
80101198:	75 19                	jne    801011b3 <fileclose+0xe6>
    begin_op();
8010119a:	e8 7d 24 00 00       	call   8010361c <begin_op>
    iput(ff.ip);
8010119f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011a2:	83 ec 0c             	sub    $0xc,%esp
801011a5:	50                   	push   %eax
801011a6:	e8 0b 0a 00 00       	call   80101bb6 <iput>
801011ab:	83 c4 10             	add    $0x10,%esp
    end_op();
801011ae:	e8 f5 24 00 00       	call   801036a8 <end_op>
  }
}
801011b3:	c9                   	leave  
801011b4:	c3                   	ret    

801011b5 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011b5:	55                   	push   %ebp
801011b6:	89 e5                	mov    %esp,%ebp
801011b8:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011bb:	8b 45 08             	mov    0x8(%ebp),%eax
801011be:	8b 00                	mov    (%eax),%eax
801011c0:	83 f8 02             	cmp    $0x2,%eax
801011c3:	75 40                	jne    80101205 <filestat+0x50>
    ilock(f->ip);
801011c5:	8b 45 08             	mov    0x8(%ebp),%eax
801011c8:	8b 40 10             	mov    0x10(%eax),%eax
801011cb:	83 ec 0c             	sub    $0xc,%esp
801011ce:	50                   	push   %eax
801011cf:	e8 12 08 00 00       	call   801019e6 <ilock>
801011d4:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011d7:	8b 45 08             	mov    0x8(%ebp),%eax
801011da:	8b 40 10             	mov    0x10(%eax),%eax
801011dd:	83 ec 08             	sub    $0x8,%esp
801011e0:	ff 75 0c             	pushl  0xc(%ebp)
801011e3:	50                   	push   %eax
801011e4:	e8 25 0d 00 00       	call   80101f0e <stati>
801011e9:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011ec:	8b 45 08             	mov    0x8(%ebp),%eax
801011ef:	8b 40 10             	mov    0x10(%eax),%eax
801011f2:	83 ec 0c             	sub    $0xc,%esp
801011f5:	50                   	push   %eax
801011f6:	e8 49 09 00 00       	call   80101b44 <iunlock>
801011fb:	83 c4 10             	add    $0x10,%esp
    return 0;
801011fe:	b8 00 00 00 00       	mov    $0x0,%eax
80101203:	eb 05                	jmp    8010120a <filestat+0x55>
  }
  return -1;
80101205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010120a:	c9                   	leave  
8010120b:	c3                   	ret    

8010120c <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010120c:	55                   	push   %ebp
8010120d:	89 e5                	mov    %esp,%ebp
8010120f:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101212:	8b 45 08             	mov    0x8(%ebp),%eax
80101215:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101219:	84 c0                	test   %al,%al
8010121b:	75 0a                	jne    80101227 <fileread+0x1b>
    return -1;
8010121d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101222:	e9 9b 00 00 00       	jmp    801012c2 <fileread+0xb6>
  if(f->type == FD_PIPE)
80101227:	8b 45 08             	mov    0x8(%ebp),%eax
8010122a:	8b 00                	mov    (%eax),%eax
8010122c:	83 f8 01             	cmp    $0x1,%eax
8010122f:	75 1a                	jne    8010124b <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101231:	8b 45 08             	mov    0x8(%ebp),%eax
80101234:	8b 40 0c             	mov    0xc(%eax),%eax
80101237:	83 ec 04             	sub    $0x4,%esp
8010123a:	ff 75 10             	pushl  0x10(%ebp)
8010123d:	ff 75 0c             	pushl  0xc(%ebp)
80101240:	50                   	push   %eax
80101241:	e8 c5 31 00 00       	call   8010440b <piperead>
80101246:	83 c4 10             	add    $0x10,%esp
80101249:	eb 77                	jmp    801012c2 <fileread+0xb6>
  if(f->type == FD_INODE){
8010124b:	8b 45 08             	mov    0x8(%ebp),%eax
8010124e:	8b 00                	mov    (%eax),%eax
80101250:	83 f8 02             	cmp    $0x2,%eax
80101253:	75 60                	jne    801012b5 <fileread+0xa9>
    ilock(f->ip);
80101255:	8b 45 08             	mov    0x8(%ebp),%eax
80101258:	8b 40 10             	mov    0x10(%eax),%eax
8010125b:	83 ec 0c             	sub    $0xc,%esp
8010125e:	50                   	push   %eax
8010125f:	e8 82 07 00 00       	call   801019e6 <ilock>
80101264:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101267:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010126a:	8b 45 08             	mov    0x8(%ebp),%eax
8010126d:	8b 50 14             	mov    0x14(%eax),%edx
80101270:	8b 45 08             	mov    0x8(%ebp),%eax
80101273:	8b 40 10             	mov    0x10(%eax),%eax
80101276:	51                   	push   %ecx
80101277:	52                   	push   %edx
80101278:	ff 75 0c             	pushl  0xc(%ebp)
8010127b:	50                   	push   %eax
8010127c:	e8 d3 0c 00 00       	call   80101f54 <readi>
80101281:	83 c4 10             	add    $0x10,%esp
80101284:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101287:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010128b:	7e 11                	jle    8010129e <fileread+0x92>
      f->off += r;
8010128d:	8b 45 08             	mov    0x8(%ebp),%eax
80101290:	8b 50 14             	mov    0x14(%eax),%edx
80101293:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101296:	01 c2                	add    %eax,%edx
80101298:	8b 45 08             	mov    0x8(%ebp),%eax
8010129b:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010129e:	8b 45 08             	mov    0x8(%ebp),%eax
801012a1:	8b 40 10             	mov    0x10(%eax),%eax
801012a4:	83 ec 0c             	sub    $0xc,%esp
801012a7:	50                   	push   %eax
801012a8:	e8 97 08 00 00       	call   80101b44 <iunlock>
801012ad:	83 c4 10             	add    $0x10,%esp
    return r;
801012b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012b3:	eb 0d                	jmp    801012c2 <fileread+0xb6>
  }
  panic("fileread");
801012b5:	83 ec 0c             	sub    $0xc,%esp
801012b8:	68 03 8a 10 80       	push   $0x80108a03
801012bd:	e8 20 f3 ff ff       	call   801005e2 <panic>
}
801012c2:	c9                   	leave  
801012c3:	c3                   	ret    

801012c4 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012c4:	55                   	push   %ebp
801012c5:	89 e5                	mov    %esp,%ebp
801012c7:	53                   	push   %ebx
801012c8:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012cb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ce:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012d2:	84 c0                	test   %al,%al
801012d4:	75 0a                	jne    801012e0 <filewrite+0x1c>
    return -1;
801012d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012db:	e9 1b 01 00 00       	jmp    801013fb <filewrite+0x137>
  if(f->type == FD_PIPE)
801012e0:	8b 45 08             	mov    0x8(%ebp),%eax
801012e3:	8b 00                	mov    (%eax),%eax
801012e5:	83 f8 01             	cmp    $0x1,%eax
801012e8:	75 1d                	jne    80101307 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012ea:	8b 45 08             	mov    0x8(%ebp),%eax
801012ed:	8b 40 0c             	mov    0xc(%eax),%eax
801012f0:	83 ec 04             	sub    $0x4,%esp
801012f3:	ff 75 10             	pushl  0x10(%ebp)
801012f6:	ff 75 0c             	pushl  0xc(%ebp)
801012f9:	50                   	push   %eax
801012fa:	e8 0e 30 00 00       	call   8010430d <pipewrite>
801012ff:	83 c4 10             	add    $0x10,%esp
80101302:	e9 f4 00 00 00       	jmp    801013fb <filewrite+0x137>
  if(f->type == FD_INODE){
80101307:	8b 45 08             	mov    0x8(%ebp),%eax
8010130a:	8b 00                	mov    (%eax),%eax
8010130c:	83 f8 02             	cmp    $0x2,%eax
8010130f:	0f 85 d9 00 00 00    	jne    801013ee <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101315:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010131c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101323:	e9 a3 00 00 00       	jmp    801013cb <filewrite+0x107>
      int n1 = n - i;
80101328:	8b 45 10             	mov    0x10(%ebp),%eax
8010132b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010132e:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101331:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101334:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101337:	7e 06                	jle    8010133f <filewrite+0x7b>
        n1 = max;
80101339:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010133c:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010133f:	e8 d8 22 00 00       	call   8010361c <begin_op>
      ilock(f->ip);
80101344:	8b 45 08             	mov    0x8(%ebp),%eax
80101347:	8b 40 10             	mov    0x10(%eax),%eax
8010134a:	83 ec 0c             	sub    $0xc,%esp
8010134d:	50                   	push   %eax
8010134e:	e8 93 06 00 00       	call   801019e6 <ilock>
80101353:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101356:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101359:	8b 45 08             	mov    0x8(%ebp),%eax
8010135c:	8b 50 14             	mov    0x14(%eax),%edx
8010135f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101362:	8b 45 0c             	mov    0xc(%ebp),%eax
80101365:	01 c3                	add    %eax,%ebx
80101367:	8b 45 08             	mov    0x8(%ebp),%eax
8010136a:	8b 40 10             	mov    0x10(%eax),%eax
8010136d:	51                   	push   %ecx
8010136e:	52                   	push   %edx
8010136f:	53                   	push   %ebx
80101370:	50                   	push   %eax
80101371:	e8 35 0d 00 00       	call   801020ab <writei>
80101376:	83 c4 10             	add    $0x10,%esp
80101379:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010137c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101380:	7e 11                	jle    80101393 <filewrite+0xcf>
        f->off += r;
80101382:	8b 45 08             	mov    0x8(%ebp),%eax
80101385:	8b 50 14             	mov    0x14(%eax),%edx
80101388:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010138b:	01 c2                	add    %eax,%edx
8010138d:	8b 45 08             	mov    0x8(%ebp),%eax
80101390:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101393:	8b 45 08             	mov    0x8(%ebp),%eax
80101396:	8b 40 10             	mov    0x10(%eax),%eax
80101399:	83 ec 0c             	sub    $0xc,%esp
8010139c:	50                   	push   %eax
8010139d:	e8 a2 07 00 00       	call   80101b44 <iunlock>
801013a2:	83 c4 10             	add    $0x10,%esp
      end_op();
801013a5:	e8 fe 22 00 00       	call   801036a8 <end_op>

      if(r < 0)
801013aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013ae:	78 29                	js     801013d9 <filewrite+0x115>
        break;
      if(r != n1)
801013b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013b6:	74 0d                	je     801013c5 <filewrite+0x101>
        panic("short filewrite");
801013b8:	83 ec 0c             	sub    $0xc,%esp
801013bb:	68 0c 8a 10 80       	push   $0x80108a0c
801013c0:	e8 1d f2 ff ff       	call   801005e2 <panic>
      i += r;
801013c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013c8:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
801013cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ce:	3b 45 10             	cmp    0x10(%ebp),%eax
801013d1:	0f 8c 51 ff ff ff    	jl     80101328 <filewrite+0x64>
801013d7:	eb 01                	jmp    801013da <filewrite+0x116>
        break;
801013d9:	90                   	nop
    }
    return i == n ? n : -1;
801013da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013dd:	3b 45 10             	cmp    0x10(%ebp),%eax
801013e0:	75 05                	jne    801013e7 <filewrite+0x123>
801013e2:	8b 45 10             	mov    0x10(%ebp),%eax
801013e5:	eb 14                	jmp    801013fb <filewrite+0x137>
801013e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013ec:	eb 0d                	jmp    801013fb <filewrite+0x137>
  }
  panic("filewrite");
801013ee:	83 ec 0c             	sub    $0xc,%esp
801013f1:	68 1c 8a 10 80       	push   $0x80108a1c
801013f6:	e8 e7 f1 ff ff       	call   801005e2 <panic>
}
801013fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013fe:	c9                   	leave  
801013ff:	c3                   	ret    

80101400 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101406:	8b 45 08             	mov    0x8(%ebp),%eax
80101409:	83 ec 08             	sub    $0x8,%esp
8010140c:	6a 01                	push   $0x1
8010140e:	50                   	push   %eax
8010140f:	e8 a2 ed ff ff       	call   801001b6 <bread>
80101414:	83 c4 10             	add    $0x10,%esp
80101417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010141a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010141d:	83 c0 18             	add    $0x18,%eax
80101420:	83 ec 04             	sub    $0x4,%esp
80101423:	6a 1c                	push   $0x1c
80101425:	50                   	push   %eax
80101426:	ff 75 0c             	pushl  0xc(%ebp)
80101429:	e8 a2 40 00 00       	call   801054d0 <memmove>
8010142e:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101431:	83 ec 0c             	sub    $0xc,%esp
80101434:	ff 75 f4             	pushl  -0xc(%ebp)
80101437:	e8 f2 ed ff ff       	call   8010022e <brelse>
8010143c:	83 c4 10             	add    $0x10,%esp
}
8010143f:	90                   	nop
80101440:	c9                   	leave  
80101441:	c3                   	ret    

80101442 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101442:	55                   	push   %ebp
80101443:	89 e5                	mov    %esp,%ebp
80101445:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101448:	8b 55 0c             	mov    0xc(%ebp),%edx
8010144b:	8b 45 08             	mov    0x8(%ebp),%eax
8010144e:	83 ec 08             	sub    $0x8,%esp
80101451:	52                   	push   %edx
80101452:	50                   	push   %eax
80101453:	e8 5e ed ff ff       	call   801001b6 <bread>
80101458:	83 c4 10             	add    $0x10,%esp
8010145b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010145e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101461:	83 c0 18             	add    $0x18,%eax
80101464:	83 ec 04             	sub    $0x4,%esp
80101467:	68 00 02 00 00       	push   $0x200
8010146c:	6a 00                	push   $0x0
8010146e:	50                   	push   %eax
8010146f:	e8 9d 3f 00 00       	call   80105411 <memset>
80101474:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101477:	83 ec 0c             	sub    $0xc,%esp
8010147a:	ff 75 f4             	pushl  -0xc(%ebp)
8010147d:	e8 d2 23 00 00       	call   80103854 <log_write>
80101482:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	ff 75 f4             	pushl  -0xc(%ebp)
8010148b:	e8 9e ed ff ff       	call   8010022e <brelse>
80101490:	83 c4 10             	add    $0x10,%esp
}
80101493:	90                   	nop
80101494:	c9                   	leave  
80101495:	c3                   	ret    

80101496 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101496:	55                   	push   %ebp
80101497:	89 e5                	mov    %esp,%ebp
80101499:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010149c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014aa:	e9 13 01 00 00       	jmp    801015c2 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801014af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014b2:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014b8:	85 c0                	test   %eax,%eax
801014ba:	0f 48 c2             	cmovs  %edx,%eax
801014bd:	c1 f8 0c             	sar    $0xc,%eax
801014c0:	89 c2                	mov    %eax,%edx
801014c2:	a1 18 2c 11 80       	mov    0x80112c18,%eax
801014c7:	01 d0                	add    %edx,%eax
801014c9:	83 ec 08             	sub    $0x8,%esp
801014cc:	50                   	push   %eax
801014cd:	ff 75 08             	pushl  0x8(%ebp)
801014d0:	e8 e1 ec ff ff       	call   801001b6 <bread>
801014d5:	83 c4 10             	add    $0x10,%esp
801014d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014e2:	e9 a6 00 00 00       	jmp    8010158d <balloc+0xf7>
      m = 1 << (bi % 8);
801014e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ea:	99                   	cltd   
801014eb:	c1 ea 1d             	shr    $0x1d,%edx
801014ee:	01 d0                	add    %edx,%eax
801014f0:	83 e0 07             	and    $0x7,%eax
801014f3:	29 d0                	sub    %edx,%eax
801014f5:	ba 01 00 00 00       	mov    $0x1,%edx
801014fa:	89 c1                	mov    %eax,%ecx
801014fc:	d3 e2                	shl    %cl,%edx
801014fe:	89 d0                	mov    %edx,%eax
80101500:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101503:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101506:	8d 50 07             	lea    0x7(%eax),%edx
80101509:	85 c0                	test   %eax,%eax
8010150b:	0f 48 c2             	cmovs  %edx,%eax
8010150e:	c1 f8 03             	sar    $0x3,%eax
80101511:	89 c2                	mov    %eax,%edx
80101513:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101516:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010151b:	0f b6 c0             	movzbl %al,%eax
8010151e:	23 45 e8             	and    -0x18(%ebp),%eax
80101521:	85 c0                	test   %eax,%eax
80101523:	75 64                	jne    80101589 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
80101525:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101528:	8d 50 07             	lea    0x7(%eax),%edx
8010152b:	85 c0                	test   %eax,%eax
8010152d:	0f 48 c2             	cmovs  %edx,%eax
80101530:	c1 f8 03             	sar    $0x3,%eax
80101533:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101536:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010153b:	89 d1                	mov    %edx,%ecx
8010153d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101540:	09 ca                	or     %ecx,%edx
80101542:	89 d1                	mov    %edx,%ecx
80101544:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101547:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010154b:	83 ec 0c             	sub    $0xc,%esp
8010154e:	ff 75 ec             	pushl  -0x14(%ebp)
80101551:	e8 fe 22 00 00       	call   80103854 <log_write>
80101556:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101559:	83 ec 0c             	sub    $0xc,%esp
8010155c:	ff 75 ec             	pushl  -0x14(%ebp)
8010155f:	e8 ca ec ff ff       	call   8010022e <brelse>
80101564:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101567:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010156a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156d:	01 c2                	add    %eax,%edx
8010156f:	8b 45 08             	mov    0x8(%ebp),%eax
80101572:	83 ec 08             	sub    $0x8,%esp
80101575:	52                   	push   %edx
80101576:	50                   	push   %eax
80101577:	e8 c6 fe ff ff       	call   80101442 <bzero>
8010157c:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010157f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101582:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101585:	01 d0                	add    %edx,%eax
80101587:	eb 57                	jmp    801015e0 <balloc+0x14a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101589:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010158d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101594:	7f 17                	jg     801015ad <balloc+0x117>
80101596:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101599:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159c:	01 d0                	add    %edx,%eax
8010159e:	89 c2                	mov    %eax,%edx
801015a0:	a1 00 2c 11 80       	mov    0x80112c00,%eax
801015a5:	39 c2                	cmp    %eax,%edx
801015a7:	0f 82 3a ff ff ff    	jb     801014e7 <balloc+0x51>
      }
    }
    brelse(bp);
801015ad:	83 ec 0c             	sub    $0xc,%esp
801015b0:	ff 75 ec             	pushl  -0x14(%ebp)
801015b3:	e8 76 ec ff ff       	call   8010022e <brelse>
801015b8:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801015bb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015c2:	8b 15 00 2c 11 80    	mov    0x80112c00,%edx
801015c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015cb:	39 c2                	cmp    %eax,%edx
801015cd:	0f 87 dc fe ff ff    	ja     801014af <balloc+0x19>
  }
  panic("balloc: out of blocks");
801015d3:	83 ec 0c             	sub    $0xc,%esp
801015d6:	68 28 8a 10 80       	push   $0x80108a28
801015db:	e8 02 f0 ff ff       	call   801005e2 <panic>
}
801015e0:	c9                   	leave  
801015e1:	c3                   	ret    

801015e2 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015e2:	55                   	push   %ebp
801015e3:	89 e5                	mov    %esp,%ebp
801015e5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	68 00 2c 11 80       	push   $0x80112c00
801015f0:	ff 75 08             	pushl  0x8(%ebp)
801015f3:	e8 08 fe ff ff       	call   80101400 <readsb>
801015f8:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801015fe:	c1 e8 0c             	shr    $0xc,%eax
80101601:	89 c2                	mov    %eax,%edx
80101603:	a1 18 2c 11 80       	mov    0x80112c18,%eax
80101608:	01 c2                	add    %eax,%edx
8010160a:	8b 45 08             	mov    0x8(%ebp),%eax
8010160d:	83 ec 08             	sub    $0x8,%esp
80101610:	52                   	push   %edx
80101611:	50                   	push   %eax
80101612:	e8 9f eb ff ff       	call   801001b6 <bread>
80101617:	83 c4 10             	add    $0x10,%esp
8010161a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010161d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101620:	25 ff 0f 00 00       	and    $0xfff,%eax
80101625:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101628:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010162b:	99                   	cltd   
8010162c:	c1 ea 1d             	shr    $0x1d,%edx
8010162f:	01 d0                	add    %edx,%eax
80101631:	83 e0 07             	and    $0x7,%eax
80101634:	29 d0                	sub    %edx,%eax
80101636:	ba 01 00 00 00       	mov    $0x1,%edx
8010163b:	89 c1                	mov    %eax,%ecx
8010163d:	d3 e2                	shl    %cl,%edx
8010163f:	89 d0                	mov    %edx,%eax
80101641:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101644:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101647:	8d 50 07             	lea    0x7(%eax),%edx
8010164a:	85 c0                	test   %eax,%eax
8010164c:	0f 48 c2             	cmovs  %edx,%eax
8010164f:	c1 f8 03             	sar    $0x3,%eax
80101652:	89 c2                	mov    %eax,%edx
80101654:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101657:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010165c:	0f b6 c0             	movzbl %al,%eax
8010165f:	23 45 ec             	and    -0x14(%ebp),%eax
80101662:	85 c0                	test   %eax,%eax
80101664:	75 0d                	jne    80101673 <bfree+0x91>
    panic("freeing free block");
80101666:	83 ec 0c             	sub    $0xc,%esp
80101669:	68 3e 8a 10 80       	push   $0x80108a3e
8010166e:	e8 6f ef ff ff       	call   801005e2 <panic>
  bp->data[bi/8] &= ~m;
80101673:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101676:	8d 50 07             	lea    0x7(%eax),%edx
80101679:	85 c0                	test   %eax,%eax
8010167b:	0f 48 c2             	cmovs  %edx,%eax
8010167e:	c1 f8 03             	sar    $0x3,%eax
80101681:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101684:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101689:	89 d1                	mov    %edx,%ecx
8010168b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010168e:	f7 d2                	not    %edx
80101690:	21 ca                	and    %ecx,%edx
80101692:	89 d1                	mov    %edx,%ecx
80101694:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101697:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010169b:	83 ec 0c             	sub    $0xc,%esp
8010169e:	ff 75 f4             	pushl  -0xc(%ebp)
801016a1:	e8 ae 21 00 00       	call   80103854 <log_write>
801016a6:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016a9:	83 ec 0c             	sub    $0xc,%esp
801016ac:	ff 75 f4             	pushl  -0xc(%ebp)
801016af:	e8 7a eb ff ff       	call   8010022e <brelse>
801016b4:	83 c4 10             	add    $0x10,%esp
}
801016b7:	90                   	nop
801016b8:	c9                   	leave  
801016b9:	c3                   	ret    

801016ba <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016ba:	55                   	push   %ebp
801016bb:	89 e5                	mov    %esp,%ebp
801016bd:	57                   	push   %edi
801016be:	56                   	push   %esi
801016bf:	53                   	push   %ebx
801016c0:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	68 51 8a 10 80       	push   $0x80108a51
801016cb:	68 20 2c 11 80       	push   $0x80112c20
801016d0:	e8 b7 3a 00 00       	call   8010518c <initlock>
801016d5:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801016d8:	83 ec 08             	sub    $0x8,%esp
801016db:	68 00 2c 11 80       	push   $0x80112c00
801016e0:	ff 75 08             	pushl  0x8(%ebp)
801016e3:	e8 18 fd ff ff       	call   80101400 <readsb>
801016e8:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
801016eb:	a1 18 2c 11 80       	mov    0x80112c18,%eax
801016f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801016f3:	8b 3d 14 2c 11 80    	mov    0x80112c14,%edi
801016f9:	8b 35 10 2c 11 80    	mov    0x80112c10,%esi
801016ff:	8b 1d 0c 2c 11 80    	mov    0x80112c0c,%ebx
80101705:	8b 0d 08 2c 11 80    	mov    0x80112c08,%ecx
8010170b:	8b 15 04 2c 11 80    	mov    0x80112c04,%edx
80101711:	a1 00 2c 11 80       	mov    0x80112c00,%eax
80101716:	ff 75 e4             	pushl  -0x1c(%ebp)
80101719:	57                   	push   %edi
8010171a:	56                   	push   %esi
8010171b:	53                   	push   %ebx
8010171c:	51                   	push   %ecx
8010171d:	52                   	push   %edx
8010171e:	50                   	push   %eax
8010171f:	68 58 8a 10 80       	push   $0x80108a58
80101724:	e8 f1 ec ff ff       	call   8010041a <cprintf>
80101729:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
8010172c:	90                   	nop
8010172d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101730:	5b                   	pop    %ebx
80101731:	5e                   	pop    %esi
80101732:	5f                   	pop    %edi
80101733:	5d                   	pop    %ebp
80101734:	c3                   	ret    

80101735 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101735:	55                   	push   %ebp
80101736:	89 e5                	mov    %esp,%ebp
80101738:	83 ec 28             	sub    $0x28,%esp
8010173b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010173e:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101742:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101749:	e9 9e 00 00 00       	jmp    801017ec <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
8010174e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101751:	c1 e8 03             	shr    $0x3,%eax
80101754:	89 c2                	mov    %eax,%edx
80101756:	a1 14 2c 11 80       	mov    0x80112c14,%eax
8010175b:	01 d0                	add    %edx,%eax
8010175d:	83 ec 08             	sub    $0x8,%esp
80101760:	50                   	push   %eax
80101761:	ff 75 08             	pushl  0x8(%ebp)
80101764:	e8 4d ea ff ff       	call   801001b6 <bread>
80101769:	83 c4 10             	add    $0x10,%esp
8010176c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010176f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101772:	8d 50 18             	lea    0x18(%eax),%edx
80101775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101778:	83 e0 07             	and    $0x7,%eax
8010177b:	c1 e0 06             	shl    $0x6,%eax
8010177e:	01 d0                	add    %edx,%eax
80101780:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101783:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101786:	0f b7 00             	movzwl (%eax),%eax
80101789:	66 85 c0             	test   %ax,%ax
8010178c:	75 4c                	jne    801017da <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
8010178e:	83 ec 04             	sub    $0x4,%esp
80101791:	6a 40                	push   $0x40
80101793:	6a 00                	push   $0x0
80101795:	ff 75 ec             	pushl  -0x14(%ebp)
80101798:	e8 74 3c 00 00       	call   80105411 <memset>
8010179d:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017a3:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017a7:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017aa:	83 ec 0c             	sub    $0xc,%esp
801017ad:	ff 75 f0             	pushl  -0x10(%ebp)
801017b0:	e8 9f 20 00 00       	call   80103854 <log_write>
801017b5:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017b8:	83 ec 0c             	sub    $0xc,%esp
801017bb:	ff 75 f0             	pushl  -0x10(%ebp)
801017be:	e8 6b ea ff ff       	call   8010022e <brelse>
801017c3:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c9:	83 ec 08             	sub    $0x8,%esp
801017cc:	50                   	push   %eax
801017cd:	ff 75 08             	pushl  0x8(%ebp)
801017d0:	e8 f8 00 00 00       	call   801018cd <iget>
801017d5:	83 c4 10             	add    $0x10,%esp
801017d8:	eb 30                	jmp    8010180a <ialloc+0xd5>
    }
    brelse(bp);
801017da:	83 ec 0c             	sub    $0xc,%esp
801017dd:	ff 75 f0             	pushl  -0x10(%ebp)
801017e0:	e8 49 ea ff ff       	call   8010022e <brelse>
801017e5:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801017ec:	8b 15 08 2c 11 80    	mov    0x80112c08,%edx
801017f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f5:	39 c2                	cmp    %eax,%edx
801017f7:	0f 87 51 ff ff ff    	ja     8010174e <ialloc+0x19>
  }
  panic("ialloc: no inodes");
801017fd:	83 ec 0c             	sub    $0xc,%esp
80101800:	68 ab 8a 10 80       	push   $0x80108aab
80101805:	e8 d8 ed ff ff       	call   801005e2 <panic>
}
8010180a:	c9                   	leave  
8010180b:	c3                   	ret    

8010180c <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010180c:	55                   	push   %ebp
8010180d:	89 e5                	mov    %esp,%ebp
8010180f:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101812:	8b 45 08             	mov    0x8(%ebp),%eax
80101815:	8b 40 04             	mov    0x4(%eax),%eax
80101818:	c1 e8 03             	shr    $0x3,%eax
8010181b:	89 c2                	mov    %eax,%edx
8010181d:	a1 14 2c 11 80       	mov    0x80112c14,%eax
80101822:	01 c2                	add    %eax,%edx
80101824:	8b 45 08             	mov    0x8(%ebp),%eax
80101827:	8b 00                	mov    (%eax),%eax
80101829:	83 ec 08             	sub    $0x8,%esp
8010182c:	52                   	push   %edx
8010182d:	50                   	push   %eax
8010182e:	e8 83 e9 ff ff       	call   801001b6 <bread>
80101833:	83 c4 10             	add    $0x10,%esp
80101836:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183c:	8d 50 18             	lea    0x18(%eax),%edx
8010183f:	8b 45 08             	mov    0x8(%ebp),%eax
80101842:	8b 40 04             	mov    0x4(%eax),%eax
80101845:	83 e0 07             	and    $0x7,%eax
80101848:	c1 e0 06             	shl    $0x6,%eax
8010184b:	01 d0                	add    %edx,%eax
8010184d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101850:	8b 45 08             	mov    0x8(%ebp),%eax
80101853:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101857:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010185a:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010185d:	8b 45 08             	mov    0x8(%ebp),%eax
80101860:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101864:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101867:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010186b:	8b 45 08             	mov    0x8(%ebp),%eax
8010186e:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101872:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101875:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101879:	8b 45 08             	mov    0x8(%ebp),%eax
8010187c:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101880:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101883:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101887:	8b 45 08             	mov    0x8(%ebp),%eax
8010188a:	8b 50 18             	mov    0x18(%eax),%edx
8010188d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101890:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101893:	8b 45 08             	mov    0x8(%ebp),%eax
80101896:	8d 50 1c             	lea    0x1c(%eax),%edx
80101899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189c:	83 c0 0c             	add    $0xc,%eax
8010189f:	83 ec 04             	sub    $0x4,%esp
801018a2:	6a 34                	push   $0x34
801018a4:	52                   	push   %edx
801018a5:	50                   	push   %eax
801018a6:	e8 25 3c 00 00       	call   801054d0 <memmove>
801018ab:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018ae:	83 ec 0c             	sub    $0xc,%esp
801018b1:	ff 75 f4             	pushl  -0xc(%ebp)
801018b4:	e8 9b 1f 00 00       	call   80103854 <log_write>
801018b9:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018bc:	83 ec 0c             	sub    $0xc,%esp
801018bf:	ff 75 f4             	pushl  -0xc(%ebp)
801018c2:	e8 67 e9 ff ff       	call   8010022e <brelse>
801018c7:	83 c4 10             	add    $0x10,%esp
}
801018ca:	90                   	nop
801018cb:	c9                   	leave  
801018cc:	c3                   	ret    

801018cd <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018cd:	55                   	push   %ebp
801018ce:	89 e5                	mov    %esp,%ebp
801018d0:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018d3:	83 ec 0c             	sub    $0xc,%esp
801018d6:	68 20 2c 11 80       	push   $0x80112c20
801018db:	e8 ce 38 00 00       	call   801051ae <acquire>
801018e0:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801018e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018ea:	c7 45 f4 54 2c 11 80 	movl   $0x80112c54,-0xc(%ebp)
801018f1:	eb 5d                	jmp    80101950 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f6:	8b 40 08             	mov    0x8(%eax),%eax
801018f9:	85 c0                	test   %eax,%eax
801018fb:	7e 39                	jle    80101936 <iget+0x69>
801018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101900:	8b 00                	mov    (%eax),%eax
80101902:	3b 45 08             	cmp    0x8(%ebp),%eax
80101905:	75 2f                	jne    80101936 <iget+0x69>
80101907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190a:	8b 40 04             	mov    0x4(%eax),%eax
8010190d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101910:	75 24                	jne    80101936 <iget+0x69>
      ip->ref++;
80101912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101915:	8b 40 08             	mov    0x8(%eax),%eax
80101918:	8d 50 01             	lea    0x1(%eax),%edx
8010191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191e:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101921:	83 ec 0c             	sub    $0xc,%esp
80101924:	68 20 2c 11 80       	push   $0x80112c20
80101929:	e8 e7 38 00 00       	call   80105215 <release>
8010192e:	83 c4 10             	add    $0x10,%esp
      return ip;
80101931:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101934:	eb 74                	jmp    801019aa <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101936:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010193a:	75 10                	jne    8010194c <iget+0x7f>
8010193c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193f:	8b 40 08             	mov    0x8(%eax),%eax
80101942:	85 c0                	test   %eax,%eax
80101944:	75 06                	jne    8010194c <iget+0x7f>
      empty = ip;
80101946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101949:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010194c:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101950:	81 7d f4 f4 3b 11 80 	cmpl   $0x80113bf4,-0xc(%ebp)
80101957:	72 9a                	jb     801018f3 <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101959:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010195d:	75 0d                	jne    8010196c <iget+0x9f>
    panic("iget: no inodes");
8010195f:	83 ec 0c             	sub    $0xc,%esp
80101962:	68 bd 8a 10 80       	push   $0x80108abd
80101967:	e8 76 ec ff ff       	call   801005e2 <panic>

  ip = empty;
8010196c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010196f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101972:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101975:	8b 55 08             	mov    0x8(%ebp),%edx
80101978:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010197a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101980:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101986:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010198d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101990:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101997:	83 ec 0c             	sub    $0xc,%esp
8010199a:	68 20 2c 11 80       	push   $0x80112c20
8010199f:	e8 71 38 00 00       	call   80105215 <release>
801019a4:	83 c4 10             	add    $0x10,%esp

  return ip;
801019a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019aa:	c9                   	leave  
801019ab:	c3                   	ret    

801019ac <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019ac:	55                   	push   %ebp
801019ad:	89 e5                	mov    %esp,%ebp
801019af:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019b2:	83 ec 0c             	sub    $0xc,%esp
801019b5:	68 20 2c 11 80       	push   $0x80112c20
801019ba:	e8 ef 37 00 00       	call   801051ae <acquire>
801019bf:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019c2:	8b 45 08             	mov    0x8(%ebp),%eax
801019c5:	8b 40 08             	mov    0x8(%eax),%eax
801019c8:	8d 50 01             	lea    0x1(%eax),%edx
801019cb:	8b 45 08             	mov    0x8(%ebp),%eax
801019ce:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019d1:	83 ec 0c             	sub    $0xc,%esp
801019d4:	68 20 2c 11 80       	push   $0x80112c20
801019d9:	e8 37 38 00 00       	call   80105215 <release>
801019de:	83 c4 10             	add    $0x10,%esp
  return ip;
801019e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801019e4:	c9                   	leave  
801019e5:	c3                   	ret    

801019e6 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801019e6:	55                   	push   %ebp
801019e7:	89 e5                	mov    %esp,%ebp
801019e9:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801019ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019f0:	74 0a                	je     801019fc <ilock+0x16>
801019f2:	8b 45 08             	mov    0x8(%ebp),%eax
801019f5:	8b 40 08             	mov    0x8(%eax),%eax
801019f8:	85 c0                	test   %eax,%eax
801019fa:	7f 0d                	jg     80101a09 <ilock+0x23>
    panic("ilock");
801019fc:	83 ec 0c             	sub    $0xc,%esp
801019ff:	68 cd 8a 10 80       	push   $0x80108acd
80101a04:	e8 d9 eb ff ff       	call   801005e2 <panic>

  acquire(&icache.lock);
80101a09:	83 ec 0c             	sub    $0xc,%esp
80101a0c:	68 20 2c 11 80       	push   $0x80112c20
80101a11:	e8 98 37 00 00       	call   801051ae <acquire>
80101a16:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a19:	eb 13                	jmp    80101a2e <ilock+0x48>
    sleep(ip, &icache.lock);
80101a1b:	83 ec 08             	sub    $0x8,%esp
80101a1e:	68 20 2c 11 80       	push   $0x80112c20
80101a23:	ff 75 08             	pushl  0x8(%ebp)
80101a26:	e8 8a 34 00 00       	call   80104eb5 <sleep>
80101a2b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a31:	8b 40 0c             	mov    0xc(%eax),%eax
80101a34:	83 e0 01             	and    $0x1,%eax
80101a37:	85 c0                	test   %eax,%eax
80101a39:	75 e0                	jne    80101a1b <ilock+0x35>
  ip->flags |= I_BUSY;
80101a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3e:	8b 40 0c             	mov    0xc(%eax),%eax
80101a41:	83 c8 01             	or     $0x1,%eax
80101a44:	89 c2                	mov    %eax,%edx
80101a46:	8b 45 08             	mov    0x8(%ebp),%eax
80101a49:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101a4c:	83 ec 0c             	sub    $0xc,%esp
80101a4f:	68 20 2c 11 80       	push   $0x80112c20
80101a54:	e8 bc 37 00 00       	call   80105215 <release>
80101a59:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5f:	8b 40 0c             	mov    0xc(%eax),%eax
80101a62:	83 e0 02             	and    $0x2,%eax
80101a65:	85 c0                	test   %eax,%eax
80101a67:	0f 85 d4 00 00 00    	jne    80101b41 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a70:	8b 40 04             	mov    0x4(%eax),%eax
80101a73:	c1 e8 03             	shr    $0x3,%eax
80101a76:	89 c2                	mov    %eax,%edx
80101a78:	a1 14 2c 11 80       	mov    0x80112c14,%eax
80101a7d:	01 c2                	add    %eax,%edx
80101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a82:	8b 00                	mov    (%eax),%eax
80101a84:	83 ec 08             	sub    $0x8,%esp
80101a87:	52                   	push   %edx
80101a88:	50                   	push   %eax
80101a89:	e8 28 e7 ff ff       	call   801001b6 <bread>
80101a8e:	83 c4 10             	add    $0x10,%esp
80101a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a97:	8d 50 18             	lea    0x18(%eax),%edx
80101a9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9d:	8b 40 04             	mov    0x4(%eax),%eax
80101aa0:	83 e0 07             	and    $0x7,%eax
80101aa3:	c1 e0 06             	shl    $0x6,%eax
80101aa6:	01 d0                	add    %edx,%eax
80101aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aae:	0f b7 10             	movzwl (%eax),%edx
80101ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab4:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101abb:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101abf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac2:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ac9:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101acd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad0:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad7:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101adb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ade:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ae5:	8b 50 08             	mov    0x8(%eax),%edx
80101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aeb:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101af1:	8d 50 0c             	lea    0xc(%eax),%edx
80101af4:	8b 45 08             	mov    0x8(%ebp),%eax
80101af7:	83 c0 1c             	add    $0x1c,%eax
80101afa:	83 ec 04             	sub    $0x4,%esp
80101afd:	6a 34                	push   $0x34
80101aff:	52                   	push   %edx
80101b00:	50                   	push   %eax
80101b01:	e8 ca 39 00 00       	call   801054d0 <memmove>
80101b06:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b09:	83 ec 0c             	sub    $0xc,%esp
80101b0c:	ff 75 f4             	pushl  -0xc(%ebp)
80101b0f:	e8 1a e7 ff ff       	call   8010022e <brelse>
80101b14:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101b17:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1a:	8b 40 0c             	mov    0xc(%eax),%eax
80101b1d:	83 c8 02             	or     $0x2,%eax
80101b20:	89 c2                	mov    %eax,%edx
80101b22:	8b 45 08             	mov    0x8(%ebp),%eax
80101b25:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101b28:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101b2f:	66 85 c0             	test   %ax,%ax
80101b32:	75 0d                	jne    80101b41 <ilock+0x15b>
      panic("ilock: no type");
80101b34:	83 ec 0c             	sub    $0xc,%esp
80101b37:	68 d3 8a 10 80       	push   $0x80108ad3
80101b3c:	e8 a1 ea ff ff       	call   801005e2 <panic>
  }
}
80101b41:	90                   	nop
80101b42:	c9                   	leave  
80101b43:	c3                   	ret    

80101b44 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b44:	55                   	push   %ebp
80101b45:	89 e5                	mov    %esp,%ebp
80101b47:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b4e:	74 17                	je     80101b67 <iunlock+0x23>
80101b50:	8b 45 08             	mov    0x8(%ebp),%eax
80101b53:	8b 40 0c             	mov    0xc(%eax),%eax
80101b56:	83 e0 01             	and    $0x1,%eax
80101b59:	85 c0                	test   %eax,%eax
80101b5b:	74 0a                	je     80101b67 <iunlock+0x23>
80101b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b60:	8b 40 08             	mov    0x8(%eax),%eax
80101b63:	85 c0                	test   %eax,%eax
80101b65:	7f 0d                	jg     80101b74 <iunlock+0x30>
    panic("iunlock");
80101b67:	83 ec 0c             	sub    $0xc,%esp
80101b6a:	68 e2 8a 10 80       	push   $0x80108ae2
80101b6f:	e8 6e ea ff ff       	call   801005e2 <panic>

  acquire(&icache.lock);
80101b74:	83 ec 0c             	sub    $0xc,%esp
80101b77:	68 20 2c 11 80       	push   $0x80112c20
80101b7c:	e8 2d 36 00 00       	call   801051ae <acquire>
80101b81:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101b84:	8b 45 08             	mov    0x8(%ebp),%eax
80101b87:	8b 40 0c             	mov    0xc(%eax),%eax
80101b8a:	83 e0 fe             	and    $0xfffffffe,%eax
80101b8d:	89 c2                	mov    %eax,%edx
80101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b92:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101b95:	83 ec 0c             	sub    $0xc,%esp
80101b98:	ff 75 08             	pushl  0x8(%ebp)
80101b9b:	e8 00 34 00 00       	call   80104fa0 <wakeup>
80101ba0:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ba3:	83 ec 0c             	sub    $0xc,%esp
80101ba6:	68 20 2c 11 80       	push   $0x80112c20
80101bab:	e8 65 36 00 00       	call   80105215 <release>
80101bb0:	83 c4 10             	add    $0x10,%esp
}
80101bb3:	90                   	nop
80101bb4:	c9                   	leave  
80101bb5:	c3                   	ret    

80101bb6 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101bb6:	55                   	push   %ebp
80101bb7:	89 e5                	mov    %esp,%ebp
80101bb9:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101bbc:	83 ec 0c             	sub    $0xc,%esp
80101bbf:	68 20 2c 11 80       	push   $0x80112c20
80101bc4:	e8 e5 35 00 00       	call   801051ae <acquire>
80101bc9:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcf:	8b 40 08             	mov    0x8(%eax),%eax
80101bd2:	83 f8 01             	cmp    $0x1,%eax
80101bd5:	0f 85 a9 00 00 00    	jne    80101c84 <iput+0xce>
80101bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bde:	8b 40 0c             	mov    0xc(%eax),%eax
80101be1:	83 e0 02             	and    $0x2,%eax
80101be4:	85 c0                	test   %eax,%eax
80101be6:	0f 84 98 00 00 00    	je     80101c84 <iput+0xce>
80101bec:	8b 45 08             	mov    0x8(%ebp),%eax
80101bef:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101bf3:	66 85 c0             	test   %ax,%ax
80101bf6:	0f 85 88 00 00 00    	jne    80101c84 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bff:	8b 40 0c             	mov    0xc(%eax),%eax
80101c02:	83 e0 01             	and    $0x1,%eax
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 0d                	je     80101c16 <iput+0x60>
      panic("iput busy");
80101c09:	83 ec 0c             	sub    $0xc,%esp
80101c0c:	68 ea 8a 10 80       	push   $0x80108aea
80101c11:	e8 cc e9 ff ff       	call   801005e2 <panic>
    ip->flags |= I_BUSY;
80101c16:	8b 45 08             	mov    0x8(%ebp),%eax
80101c19:	8b 40 0c             	mov    0xc(%eax),%eax
80101c1c:	83 c8 01             	or     $0x1,%eax
80101c1f:	89 c2                	mov    %eax,%edx
80101c21:	8b 45 08             	mov    0x8(%ebp),%eax
80101c24:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101c27:	83 ec 0c             	sub    $0xc,%esp
80101c2a:	68 20 2c 11 80       	push   $0x80112c20
80101c2f:	e8 e1 35 00 00       	call   80105215 <release>
80101c34:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	ff 75 08             	pushl  0x8(%ebp)
80101c3d:	e8 a8 01 00 00       	call   80101dea <itrunc>
80101c42:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c45:	8b 45 08             	mov    0x8(%ebp),%eax
80101c48:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c4e:	83 ec 0c             	sub    $0xc,%esp
80101c51:	ff 75 08             	pushl  0x8(%ebp)
80101c54:	e8 b3 fb ff ff       	call   8010180c <iupdate>
80101c59:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 20 2c 11 80       	push   $0x80112c20
80101c64:	e8 45 35 00 00       	call   801051ae <acquire>
80101c69:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c76:	83 ec 0c             	sub    $0xc,%esp
80101c79:	ff 75 08             	pushl  0x8(%ebp)
80101c7c:	e8 1f 33 00 00       	call   80104fa0 <wakeup>
80101c81:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101c84:	8b 45 08             	mov    0x8(%ebp),%eax
80101c87:	8b 40 08             	mov    0x8(%eax),%eax
80101c8a:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c90:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c93:	83 ec 0c             	sub    $0xc,%esp
80101c96:	68 20 2c 11 80       	push   $0x80112c20
80101c9b:	e8 75 35 00 00       	call   80105215 <release>
80101ca0:	83 c4 10             	add    $0x10,%esp
}
80101ca3:	90                   	nop
80101ca4:	c9                   	leave  
80101ca5:	c3                   	ret    

80101ca6 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101ca6:	55                   	push   %ebp
80101ca7:	89 e5                	mov    %esp,%ebp
80101ca9:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101cac:	83 ec 0c             	sub    $0xc,%esp
80101caf:	ff 75 08             	pushl  0x8(%ebp)
80101cb2:	e8 8d fe ff ff       	call   80101b44 <iunlock>
80101cb7:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101cba:	83 ec 0c             	sub    $0xc,%esp
80101cbd:	ff 75 08             	pushl  0x8(%ebp)
80101cc0:	e8 f1 fe ff ff       	call   80101bb6 <iput>
80101cc5:	83 c4 10             	add    $0x10,%esp
}
80101cc8:	90                   	nop
80101cc9:	c9                   	leave  
80101cca:	c3                   	ret    

80101ccb <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ccb:	55                   	push   %ebp
80101ccc:	89 e5                	mov    %esp,%ebp
80101cce:	53                   	push   %ebx
80101ccf:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101cd2:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101cd6:	77 42                	ja     80101d1a <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
80101cde:	83 c2 04             	add    $0x4,%edx
80101ce1:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cec:	75 24                	jne    80101d12 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101cee:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf1:	8b 00                	mov    (%eax),%eax
80101cf3:	83 ec 0c             	sub    $0xc,%esp
80101cf6:	50                   	push   %eax
80101cf7:	e8 9a f7 ff ff       	call   80101496 <balloc>
80101cfc:	83 c4 10             	add    $0x10,%esp
80101cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d02:	8b 45 08             	mov    0x8(%ebp),%eax
80101d05:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d08:	8d 4a 04             	lea    0x4(%edx),%ecx
80101d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d0e:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d15:	e9 cb 00 00 00       	jmp    80101de5 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101d1a:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d1e:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d22:	0f 87 b0 00 00 00    	ja     80101dd8 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d28:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2b:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d35:	75 1d                	jne    80101d54 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d37:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3a:	8b 00                	mov    (%eax),%eax
80101d3c:	83 ec 0c             	sub    $0xc,%esp
80101d3f:	50                   	push   %eax
80101d40:	e8 51 f7 ff ff       	call   80101496 <balloc>
80101d45:	83 c4 10             	add    $0x10,%esp
80101d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d51:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d54:	8b 45 08             	mov    0x8(%ebp),%eax
80101d57:	8b 00                	mov    (%eax),%eax
80101d59:	83 ec 08             	sub    $0x8,%esp
80101d5c:	ff 75 f4             	pushl  -0xc(%ebp)
80101d5f:	50                   	push   %eax
80101d60:	e8 51 e4 ff ff       	call   801001b6 <bread>
80101d65:	83 c4 10             	add    $0x10,%esp
80101d68:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d6e:	83 c0 18             	add    $0x18,%eax
80101d71:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d74:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d77:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d81:	01 d0                	add    %edx,%eax
80101d83:	8b 00                	mov    (%eax),%eax
80101d85:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d8c:	75 37                	jne    80101dc5 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d91:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d9b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101da1:	8b 00                	mov    (%eax),%eax
80101da3:	83 ec 0c             	sub    $0xc,%esp
80101da6:	50                   	push   %eax
80101da7:	e8 ea f6 ff ff       	call   80101496 <balloc>
80101dac:	83 c4 10             	add    $0x10,%esp
80101daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101db5:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101db7:	83 ec 0c             	sub    $0xc,%esp
80101dba:	ff 75 f0             	pushl  -0x10(%ebp)
80101dbd:	e8 92 1a 00 00       	call   80103854 <log_write>
80101dc2:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101dc5:	83 ec 0c             	sub    $0xc,%esp
80101dc8:	ff 75 f0             	pushl  -0x10(%ebp)
80101dcb:	e8 5e e4 ff ff       	call   8010022e <brelse>
80101dd0:	83 c4 10             	add    $0x10,%esp
    return addr;
80101dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dd6:	eb 0d                	jmp    80101de5 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	68 f4 8a 10 80       	push   $0x80108af4
80101de0:	e8 fd e7 ff ff       	call   801005e2 <panic>
}
80101de5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101de8:	c9                   	leave  
80101de9:	c3                   	ret    

80101dea <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101dea:	55                   	push   %ebp
80101deb:	89 e5                	mov    %esp,%ebp
80101ded:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101df0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101df7:	eb 45                	jmp    80101e3e <itrunc+0x54>
    if(ip->addrs[i]){
80101df9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dff:	83 c2 04             	add    $0x4,%edx
80101e02:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e06:	85 c0                	test   %eax,%eax
80101e08:	74 30                	je     80101e3a <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e10:	83 c2 04             	add    $0x4,%edx
80101e13:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e17:	8b 55 08             	mov    0x8(%ebp),%edx
80101e1a:	8b 12                	mov    (%edx),%edx
80101e1c:	83 ec 08             	sub    $0x8,%esp
80101e1f:	50                   	push   %eax
80101e20:	52                   	push   %edx
80101e21:	e8 bc f7 ff ff       	call   801015e2 <bfree>
80101e26:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e29:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e2f:	83 c2 04             	add    $0x4,%edx
80101e32:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e39:	00 
  for(i = 0; i < NDIRECT; i++){
80101e3a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e3e:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e42:	7e b5                	jle    80101df9 <itrunc+0xf>
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101e44:	8b 45 08             	mov    0x8(%ebp),%eax
80101e47:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	0f 84 a1 00 00 00    	je     80101ef3 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e52:	8b 45 08             	mov    0x8(%ebp),%eax
80101e55:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e58:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5b:	8b 00                	mov    (%eax),%eax
80101e5d:	83 ec 08             	sub    $0x8,%esp
80101e60:	52                   	push   %edx
80101e61:	50                   	push   %eax
80101e62:	e8 4f e3 ff ff       	call   801001b6 <bread>
80101e67:	83 c4 10             	add    $0x10,%esp
80101e6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e70:	83 c0 18             	add    $0x18,%eax
80101e73:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e76:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e7d:	eb 3c                	jmp    80101ebb <itrunc+0xd1>
      if(a[j])
80101e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e89:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e8c:	01 d0                	add    %edx,%eax
80101e8e:	8b 00                	mov    (%eax),%eax
80101e90:	85 c0                	test   %eax,%eax
80101e92:	74 23                	je     80101eb7 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e97:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ea1:	01 d0                	add    %edx,%eax
80101ea3:	8b 00                	mov    (%eax),%eax
80101ea5:	8b 55 08             	mov    0x8(%ebp),%edx
80101ea8:	8b 12                	mov    (%edx),%edx
80101eaa:	83 ec 08             	sub    $0x8,%esp
80101ead:	50                   	push   %eax
80101eae:	52                   	push   %edx
80101eaf:	e8 2e f7 ff ff       	call   801015e2 <bfree>
80101eb4:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101eb7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ebe:	83 f8 7f             	cmp    $0x7f,%eax
80101ec1:	76 bc                	jbe    80101e7f <itrunc+0x95>
    }
    brelse(bp);
80101ec3:	83 ec 0c             	sub    $0xc,%esp
80101ec6:	ff 75 ec             	pushl  -0x14(%ebp)
80101ec9:	e8 60 e3 ff ff       	call   8010022e <brelse>
80101ece:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed4:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ed7:	8b 55 08             	mov    0x8(%ebp),%edx
80101eda:	8b 12                	mov    (%edx),%edx
80101edc:	83 ec 08             	sub    $0x8,%esp
80101edf:	50                   	push   %eax
80101ee0:	52                   	push   %edx
80101ee1:	e8 fc f6 ff ff       	call   801015e2 <bfree>
80101ee6:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80101eec:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101ef3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef6:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101efd:	83 ec 0c             	sub    $0xc,%esp
80101f00:	ff 75 08             	pushl  0x8(%ebp)
80101f03:	e8 04 f9 ff ff       	call   8010180c <iupdate>
80101f08:	83 c4 10             	add    $0x10,%esp
}
80101f0b:	90                   	nop
80101f0c:	c9                   	leave  
80101f0d:	c3                   	ret    

80101f0e <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101f0e:	55                   	push   %ebp
80101f0f:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f11:	8b 45 08             	mov    0x8(%ebp),%eax
80101f14:	8b 00                	mov    (%eax),%eax
80101f16:	89 c2                	mov    %eax,%edx
80101f18:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f1b:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f21:	8b 50 04             	mov    0x4(%eax),%edx
80101f24:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f27:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2d:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101f31:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f34:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f37:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3a:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f41:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f45:	8b 45 08             	mov    0x8(%ebp),%eax
80101f48:	8b 50 18             	mov    0x18(%eax),%edx
80101f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f4e:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f51:	90                   	nop
80101f52:	5d                   	pop    %ebp
80101f53:	c3                   	ret    

80101f54 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f54:	55                   	push   %ebp
80101f55:	89 e5                	mov    %esp,%ebp
80101f57:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f61:	66 83 f8 03          	cmp    $0x3,%ax
80101f65:	75 5c                	jne    80101fc3 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f67:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f6e:	66 85 c0             	test   %ax,%ax
80101f71:	78 20                	js     80101f93 <readi+0x3f>
80101f73:	8b 45 08             	mov    0x8(%ebp),%eax
80101f76:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f7a:	66 83 f8 09          	cmp    $0x9,%ax
80101f7e:	7f 13                	jg     80101f93 <readi+0x3f>
80101f80:	8b 45 08             	mov    0x8(%ebp),%eax
80101f83:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f87:	98                   	cwtl   
80101f88:	8b 04 c5 a0 2b 11 80 	mov    -0x7feed460(,%eax,8),%eax
80101f8f:	85 c0                	test   %eax,%eax
80101f91:	75 0a                	jne    80101f9d <readi+0x49>
      return -1;
80101f93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f98:	e9 0c 01 00 00       	jmp    801020a9 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa4:	98                   	cwtl   
80101fa5:	8b 04 c5 a0 2b 11 80 	mov    -0x7feed460(,%eax,8),%eax
80101fac:	8b 55 14             	mov    0x14(%ebp),%edx
80101faf:	83 ec 04             	sub    $0x4,%esp
80101fb2:	52                   	push   %edx
80101fb3:	ff 75 0c             	pushl  0xc(%ebp)
80101fb6:	ff 75 08             	pushl  0x8(%ebp)
80101fb9:	ff d0                	call   *%eax
80101fbb:	83 c4 10             	add    $0x10,%esp
80101fbe:	e9 e6 00 00 00       	jmp    801020a9 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101fc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc6:	8b 40 18             	mov    0x18(%eax),%eax
80101fc9:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fcc:	72 0d                	jb     80101fdb <readi+0x87>
80101fce:	8b 55 10             	mov    0x10(%ebp),%edx
80101fd1:	8b 45 14             	mov    0x14(%ebp),%eax
80101fd4:	01 d0                	add    %edx,%eax
80101fd6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fd9:	73 0a                	jae    80101fe5 <readi+0x91>
    return -1;
80101fdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fe0:	e9 c4 00 00 00       	jmp    801020a9 <readi+0x155>
  if(off + n > ip->size)
80101fe5:	8b 55 10             	mov    0x10(%ebp),%edx
80101fe8:	8b 45 14             	mov    0x14(%ebp),%eax
80101feb:	01 c2                	add    %eax,%edx
80101fed:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff0:	8b 40 18             	mov    0x18(%eax),%eax
80101ff3:	39 c2                	cmp    %eax,%edx
80101ff5:	76 0c                	jbe    80102003 <readi+0xaf>
    n = ip->size - off;
80101ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffa:	8b 40 18             	mov    0x18(%eax),%eax
80101ffd:	2b 45 10             	sub    0x10(%ebp),%eax
80102000:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102003:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010200a:	e9 8b 00 00 00       	jmp    8010209a <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010200f:	8b 45 10             	mov    0x10(%ebp),%eax
80102012:	c1 e8 09             	shr    $0x9,%eax
80102015:	83 ec 08             	sub    $0x8,%esp
80102018:	50                   	push   %eax
80102019:	ff 75 08             	pushl  0x8(%ebp)
8010201c:	e8 aa fc ff ff       	call   80101ccb <bmap>
80102021:	83 c4 10             	add    $0x10,%esp
80102024:	89 c2                	mov    %eax,%edx
80102026:	8b 45 08             	mov    0x8(%ebp),%eax
80102029:	8b 00                	mov    (%eax),%eax
8010202b:	83 ec 08             	sub    $0x8,%esp
8010202e:	52                   	push   %edx
8010202f:	50                   	push   %eax
80102030:	e8 81 e1 ff ff       	call   801001b6 <bread>
80102035:	83 c4 10             	add    $0x10,%esp
80102038:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010203b:	8b 45 10             	mov    0x10(%ebp),%eax
8010203e:	25 ff 01 00 00       	and    $0x1ff,%eax
80102043:	ba 00 02 00 00       	mov    $0x200,%edx
80102048:	29 c2                	sub    %eax,%edx
8010204a:	8b 45 14             	mov    0x14(%ebp),%eax
8010204d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102050:	39 c2                	cmp    %eax,%edx
80102052:	0f 46 c2             	cmovbe %edx,%eax
80102055:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102058:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010205b:	8d 50 18             	lea    0x18(%eax),%edx
8010205e:	8b 45 10             	mov    0x10(%ebp),%eax
80102061:	25 ff 01 00 00       	and    $0x1ff,%eax
80102066:	01 d0                	add    %edx,%eax
80102068:	83 ec 04             	sub    $0x4,%esp
8010206b:	ff 75 ec             	pushl  -0x14(%ebp)
8010206e:	50                   	push   %eax
8010206f:	ff 75 0c             	pushl  0xc(%ebp)
80102072:	e8 59 34 00 00       	call   801054d0 <memmove>
80102077:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010207a:	83 ec 0c             	sub    $0xc,%esp
8010207d:	ff 75 f0             	pushl  -0x10(%ebp)
80102080:	e8 a9 e1 ff ff       	call   8010022e <brelse>
80102085:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102088:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010208b:	01 45 f4             	add    %eax,-0xc(%ebp)
8010208e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102091:	01 45 10             	add    %eax,0x10(%ebp)
80102094:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102097:	01 45 0c             	add    %eax,0xc(%ebp)
8010209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010209d:	3b 45 14             	cmp    0x14(%ebp),%eax
801020a0:	0f 82 69 ff ff ff    	jb     8010200f <readi+0xbb>
  }
  return n;
801020a6:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020a9:	c9                   	leave  
801020aa:	c3                   	ret    

801020ab <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020ab:	55                   	push   %ebp
801020ac:	89 e5                	mov    %esp,%ebp
801020ae:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020b1:	8b 45 08             	mov    0x8(%ebp),%eax
801020b4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020b8:	66 83 f8 03          	cmp    $0x3,%ax
801020bc:	75 5c                	jne    8010211a <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020be:	8b 45 08             	mov    0x8(%ebp),%eax
801020c1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020c5:	66 85 c0             	test   %ax,%ax
801020c8:	78 20                	js     801020ea <writei+0x3f>
801020ca:	8b 45 08             	mov    0x8(%ebp),%eax
801020cd:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020d1:	66 83 f8 09          	cmp    $0x9,%ax
801020d5:	7f 13                	jg     801020ea <writei+0x3f>
801020d7:	8b 45 08             	mov    0x8(%ebp),%eax
801020da:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020de:	98                   	cwtl   
801020df:	8b 04 c5 a4 2b 11 80 	mov    -0x7feed45c(,%eax,8),%eax
801020e6:	85 c0                	test   %eax,%eax
801020e8:	75 0a                	jne    801020f4 <writei+0x49>
      return -1;
801020ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020ef:	e9 3d 01 00 00       	jmp    80102231 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
801020f4:	8b 45 08             	mov    0x8(%ebp),%eax
801020f7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020fb:	98                   	cwtl   
801020fc:	8b 04 c5 a4 2b 11 80 	mov    -0x7feed45c(,%eax,8),%eax
80102103:	8b 55 14             	mov    0x14(%ebp),%edx
80102106:	83 ec 04             	sub    $0x4,%esp
80102109:	52                   	push   %edx
8010210a:	ff 75 0c             	pushl  0xc(%ebp)
8010210d:	ff 75 08             	pushl  0x8(%ebp)
80102110:	ff d0                	call   *%eax
80102112:	83 c4 10             	add    $0x10,%esp
80102115:	e9 17 01 00 00       	jmp    80102231 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
8010211a:	8b 45 08             	mov    0x8(%ebp),%eax
8010211d:	8b 40 18             	mov    0x18(%eax),%eax
80102120:	3b 45 10             	cmp    0x10(%ebp),%eax
80102123:	72 0d                	jb     80102132 <writei+0x87>
80102125:	8b 55 10             	mov    0x10(%ebp),%edx
80102128:	8b 45 14             	mov    0x14(%ebp),%eax
8010212b:	01 d0                	add    %edx,%eax
8010212d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102130:	73 0a                	jae    8010213c <writei+0x91>
    return -1;
80102132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102137:	e9 f5 00 00 00       	jmp    80102231 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
8010213c:	8b 55 10             	mov    0x10(%ebp),%edx
8010213f:	8b 45 14             	mov    0x14(%ebp),%eax
80102142:	01 d0                	add    %edx,%eax
80102144:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102149:	76 0a                	jbe    80102155 <writei+0xaa>
    return -1;
8010214b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102150:	e9 dc 00 00 00       	jmp    80102231 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102155:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010215c:	e9 99 00 00 00       	jmp    801021fa <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102161:	8b 45 10             	mov    0x10(%ebp),%eax
80102164:	c1 e8 09             	shr    $0x9,%eax
80102167:	83 ec 08             	sub    $0x8,%esp
8010216a:	50                   	push   %eax
8010216b:	ff 75 08             	pushl  0x8(%ebp)
8010216e:	e8 58 fb ff ff       	call   80101ccb <bmap>
80102173:	83 c4 10             	add    $0x10,%esp
80102176:	89 c2                	mov    %eax,%edx
80102178:	8b 45 08             	mov    0x8(%ebp),%eax
8010217b:	8b 00                	mov    (%eax),%eax
8010217d:	83 ec 08             	sub    $0x8,%esp
80102180:	52                   	push   %edx
80102181:	50                   	push   %eax
80102182:	e8 2f e0 ff ff       	call   801001b6 <bread>
80102187:	83 c4 10             	add    $0x10,%esp
8010218a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010218d:	8b 45 10             	mov    0x10(%ebp),%eax
80102190:	25 ff 01 00 00       	and    $0x1ff,%eax
80102195:	ba 00 02 00 00       	mov    $0x200,%edx
8010219a:	29 c2                	sub    %eax,%edx
8010219c:	8b 45 14             	mov    0x14(%ebp),%eax
8010219f:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021a2:	39 c2                	cmp    %eax,%edx
801021a4:	0f 46 c2             	cmovbe %edx,%eax
801021a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801021aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021ad:	8d 50 18             	lea    0x18(%eax),%edx
801021b0:	8b 45 10             	mov    0x10(%ebp),%eax
801021b3:	25 ff 01 00 00       	and    $0x1ff,%eax
801021b8:	01 d0                	add    %edx,%eax
801021ba:	83 ec 04             	sub    $0x4,%esp
801021bd:	ff 75 ec             	pushl  -0x14(%ebp)
801021c0:	ff 75 0c             	pushl  0xc(%ebp)
801021c3:	50                   	push   %eax
801021c4:	e8 07 33 00 00       	call   801054d0 <memmove>
801021c9:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801021cc:	83 ec 0c             	sub    $0xc,%esp
801021cf:	ff 75 f0             	pushl  -0x10(%ebp)
801021d2:	e8 7d 16 00 00       	call   80103854 <log_write>
801021d7:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021da:	83 ec 0c             	sub    $0xc,%esp
801021dd:	ff 75 f0             	pushl  -0x10(%ebp)
801021e0:	e8 49 e0 ff ff       	call   8010022e <brelse>
801021e5:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021eb:	01 45 f4             	add    %eax,-0xc(%ebp)
801021ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021f1:	01 45 10             	add    %eax,0x10(%ebp)
801021f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021f7:	01 45 0c             	add    %eax,0xc(%ebp)
801021fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021fd:	3b 45 14             	cmp    0x14(%ebp),%eax
80102200:	0f 82 5b ff ff ff    	jb     80102161 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
80102206:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010220a:	74 22                	je     8010222e <writei+0x183>
8010220c:	8b 45 08             	mov    0x8(%ebp),%eax
8010220f:	8b 40 18             	mov    0x18(%eax),%eax
80102212:	3b 45 10             	cmp    0x10(%ebp),%eax
80102215:	73 17                	jae    8010222e <writei+0x183>
    ip->size = off;
80102217:	8b 45 08             	mov    0x8(%ebp),%eax
8010221a:	8b 55 10             	mov    0x10(%ebp),%edx
8010221d:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102220:	83 ec 0c             	sub    $0xc,%esp
80102223:	ff 75 08             	pushl  0x8(%ebp)
80102226:	e8 e1 f5 ff ff       	call   8010180c <iupdate>
8010222b:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010222e:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102231:	c9                   	leave  
80102232:	c3                   	ret    

80102233 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102233:	55                   	push   %ebp
80102234:	89 e5                	mov    %esp,%ebp
80102236:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102239:	83 ec 04             	sub    $0x4,%esp
8010223c:	6a 0e                	push   $0xe
8010223e:	ff 75 0c             	pushl  0xc(%ebp)
80102241:	ff 75 08             	pushl  0x8(%ebp)
80102244:	e8 1d 33 00 00       	call   80105566 <strncmp>
80102249:	83 c4 10             	add    $0x10,%esp
}
8010224c:	c9                   	leave  
8010224d:	c3                   	ret    

8010224e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010224e:	55                   	push   %ebp
8010224f:	89 e5                	mov    %esp,%ebp
80102251:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102254:	8b 45 08             	mov    0x8(%ebp),%eax
80102257:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010225b:	66 83 f8 01          	cmp    $0x1,%ax
8010225f:	74 0d                	je     8010226e <dirlookup+0x20>
    panic("dirlookup not DIR");
80102261:	83 ec 0c             	sub    $0xc,%esp
80102264:	68 07 8b 10 80       	push   $0x80108b07
80102269:	e8 74 e3 ff ff       	call   801005e2 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010226e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102275:	eb 7b                	jmp    801022f2 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102277:	6a 10                	push   $0x10
80102279:	ff 75 f4             	pushl  -0xc(%ebp)
8010227c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010227f:	50                   	push   %eax
80102280:	ff 75 08             	pushl  0x8(%ebp)
80102283:	e8 cc fc ff ff       	call   80101f54 <readi>
80102288:	83 c4 10             	add    $0x10,%esp
8010228b:	83 f8 10             	cmp    $0x10,%eax
8010228e:	74 0d                	je     8010229d <dirlookup+0x4f>
      panic("dirlink read");
80102290:	83 ec 0c             	sub    $0xc,%esp
80102293:	68 19 8b 10 80       	push   $0x80108b19
80102298:	e8 45 e3 ff ff       	call   801005e2 <panic>
    if(de.inum == 0)
8010229d:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022a1:	66 85 c0             	test   %ax,%ax
801022a4:	74 47                	je     801022ed <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801022a6:	83 ec 08             	sub    $0x8,%esp
801022a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022ac:	83 c0 02             	add    $0x2,%eax
801022af:	50                   	push   %eax
801022b0:	ff 75 0c             	pushl  0xc(%ebp)
801022b3:	e8 7b ff ff ff       	call   80102233 <namecmp>
801022b8:	83 c4 10             	add    $0x10,%esp
801022bb:	85 c0                	test   %eax,%eax
801022bd:	75 2f                	jne    801022ee <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801022bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801022c3:	74 08                	je     801022cd <dirlookup+0x7f>
        *poff = off;
801022c5:	8b 45 10             	mov    0x10(%ebp),%eax
801022c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022cb:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801022cd:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022d1:	0f b7 c0             	movzwl %ax,%eax
801022d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801022d7:	8b 45 08             	mov    0x8(%ebp),%eax
801022da:	8b 00                	mov    (%eax),%eax
801022dc:	83 ec 08             	sub    $0x8,%esp
801022df:	ff 75 f0             	pushl  -0x10(%ebp)
801022e2:	50                   	push   %eax
801022e3:	e8 e5 f5 ff ff       	call   801018cd <iget>
801022e8:	83 c4 10             	add    $0x10,%esp
801022eb:	eb 19                	jmp    80102306 <dirlookup+0xb8>
      continue;
801022ed:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
801022ee:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801022f2:	8b 45 08             	mov    0x8(%ebp),%eax
801022f5:	8b 40 18             	mov    0x18(%eax),%eax
801022f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801022fb:	0f 87 76 ff ff ff    	ja     80102277 <dirlookup+0x29>
    }
  }

  return 0;
80102301:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102306:	c9                   	leave  
80102307:	c3                   	ret    

80102308 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102308:	55                   	push   %ebp
80102309:	89 e5                	mov    %esp,%ebp
8010230b:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010230e:	83 ec 04             	sub    $0x4,%esp
80102311:	6a 00                	push   $0x0
80102313:	ff 75 0c             	pushl  0xc(%ebp)
80102316:	ff 75 08             	pushl  0x8(%ebp)
80102319:	e8 30 ff ff ff       	call   8010224e <dirlookup>
8010231e:	83 c4 10             	add    $0x10,%esp
80102321:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102324:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102328:	74 18                	je     80102342 <dirlink+0x3a>
    iput(ip);
8010232a:	83 ec 0c             	sub    $0xc,%esp
8010232d:	ff 75 f0             	pushl  -0x10(%ebp)
80102330:	e8 81 f8 ff ff       	call   80101bb6 <iput>
80102335:	83 c4 10             	add    $0x10,%esp
    return -1;
80102338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010233d:	e9 9c 00 00 00       	jmp    801023de <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102342:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102349:	eb 39                	jmp    80102384 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234e:	6a 10                	push   $0x10
80102350:	50                   	push   %eax
80102351:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102354:	50                   	push   %eax
80102355:	ff 75 08             	pushl  0x8(%ebp)
80102358:	e8 f7 fb ff ff       	call   80101f54 <readi>
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	83 f8 10             	cmp    $0x10,%eax
80102363:	74 0d                	je     80102372 <dirlink+0x6a>
      panic("dirlink read");
80102365:	83 ec 0c             	sub    $0xc,%esp
80102368:	68 19 8b 10 80       	push   $0x80108b19
8010236d:	e8 70 e2 ff ff       	call   801005e2 <panic>
    if(de.inum == 0)
80102372:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102376:	66 85 c0             	test   %ax,%ax
80102379:	74 18                	je     80102393 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010237e:	83 c0 10             	add    $0x10,%eax
80102381:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102384:	8b 45 08             	mov    0x8(%ebp),%eax
80102387:	8b 50 18             	mov    0x18(%eax),%edx
8010238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010238d:	39 c2                	cmp    %eax,%edx
8010238f:	77 ba                	ja     8010234b <dirlink+0x43>
80102391:	eb 01                	jmp    80102394 <dirlink+0x8c>
      break;
80102393:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102394:	83 ec 04             	sub    $0x4,%esp
80102397:	6a 0e                	push   $0xe
80102399:	ff 75 0c             	pushl  0xc(%ebp)
8010239c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010239f:	83 c0 02             	add    $0x2,%eax
801023a2:	50                   	push   %eax
801023a3:	e8 14 32 00 00       	call   801055bc <strncpy>
801023a8:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023ab:	8b 45 10             	mov    0x10(%ebp),%eax
801023ae:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b5:	6a 10                	push   $0x10
801023b7:	50                   	push   %eax
801023b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023bb:	50                   	push   %eax
801023bc:	ff 75 08             	pushl  0x8(%ebp)
801023bf:	e8 e7 fc ff ff       	call   801020ab <writei>
801023c4:	83 c4 10             	add    $0x10,%esp
801023c7:	83 f8 10             	cmp    $0x10,%eax
801023ca:	74 0d                	je     801023d9 <dirlink+0xd1>
    panic("dirlink");
801023cc:	83 ec 0c             	sub    $0xc,%esp
801023cf:	68 26 8b 10 80       	push   $0x80108b26
801023d4:	e8 09 e2 ff ff       	call   801005e2 <panic>
  
  return 0;
801023d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023de:	c9                   	leave  
801023df:	c3                   	ret    

801023e0 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801023e6:	eb 04                	jmp    801023ec <skipelem+0xc>
    path++;
801023e8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801023ec:	8b 45 08             	mov    0x8(%ebp),%eax
801023ef:	0f b6 00             	movzbl (%eax),%eax
801023f2:	3c 2f                	cmp    $0x2f,%al
801023f4:	74 f2                	je     801023e8 <skipelem+0x8>
  if(*path == 0)
801023f6:	8b 45 08             	mov    0x8(%ebp),%eax
801023f9:	0f b6 00             	movzbl (%eax),%eax
801023fc:	84 c0                	test   %al,%al
801023fe:	75 07                	jne    80102407 <skipelem+0x27>
    return 0;
80102400:	b8 00 00 00 00       	mov    $0x0,%eax
80102405:	eb 7b                	jmp    80102482 <skipelem+0xa2>
  s = path;
80102407:	8b 45 08             	mov    0x8(%ebp),%eax
8010240a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010240d:	eb 04                	jmp    80102413 <skipelem+0x33>
    path++;
8010240f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102413:	8b 45 08             	mov    0x8(%ebp),%eax
80102416:	0f b6 00             	movzbl (%eax),%eax
80102419:	3c 2f                	cmp    $0x2f,%al
8010241b:	74 0a                	je     80102427 <skipelem+0x47>
8010241d:	8b 45 08             	mov    0x8(%ebp),%eax
80102420:	0f b6 00             	movzbl (%eax),%eax
80102423:	84 c0                	test   %al,%al
80102425:	75 e8                	jne    8010240f <skipelem+0x2f>
  len = path - s;
80102427:	8b 55 08             	mov    0x8(%ebp),%edx
8010242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010242d:	29 c2                	sub    %eax,%edx
8010242f:	89 d0                	mov    %edx,%eax
80102431:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102434:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102438:	7e 15                	jle    8010244f <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010243a:	83 ec 04             	sub    $0x4,%esp
8010243d:	6a 0e                	push   $0xe
8010243f:	ff 75 f4             	pushl  -0xc(%ebp)
80102442:	ff 75 0c             	pushl  0xc(%ebp)
80102445:	e8 86 30 00 00       	call   801054d0 <memmove>
8010244a:	83 c4 10             	add    $0x10,%esp
8010244d:	eb 26                	jmp    80102475 <skipelem+0x95>
  else {
    memmove(name, s, len);
8010244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102452:	83 ec 04             	sub    $0x4,%esp
80102455:	50                   	push   %eax
80102456:	ff 75 f4             	pushl  -0xc(%ebp)
80102459:	ff 75 0c             	pushl  0xc(%ebp)
8010245c:	e8 6f 30 00 00       	call   801054d0 <memmove>
80102461:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102464:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102467:	8b 45 0c             	mov    0xc(%ebp),%eax
8010246a:	01 d0                	add    %edx,%eax
8010246c:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010246f:	eb 04                	jmp    80102475 <skipelem+0x95>
    path++;
80102471:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102475:	8b 45 08             	mov    0x8(%ebp),%eax
80102478:	0f b6 00             	movzbl (%eax),%eax
8010247b:	3c 2f                	cmp    $0x2f,%al
8010247d:	74 f2                	je     80102471 <skipelem+0x91>
  return path;
8010247f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102482:	c9                   	leave  
80102483:	c3                   	ret    

80102484 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102484:	55                   	push   %ebp
80102485:	89 e5                	mov    %esp,%ebp
80102487:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010248a:	8b 45 08             	mov    0x8(%ebp),%eax
8010248d:	0f b6 00             	movzbl (%eax),%eax
80102490:	3c 2f                	cmp    $0x2f,%al
80102492:	75 17                	jne    801024ab <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102494:	83 ec 08             	sub    $0x8,%esp
80102497:	6a 01                	push   $0x1
80102499:	6a 01                	push   $0x1
8010249b:	e8 2d f4 ff ff       	call   801018cd <iget>
801024a0:	83 c4 10             	add    $0x10,%esp
801024a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024a6:	e9 bb 00 00 00       	jmp    80102566 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801024ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801024b1:	8b 40 68             	mov    0x68(%eax),%eax
801024b4:	83 ec 0c             	sub    $0xc,%esp
801024b7:	50                   	push   %eax
801024b8:	e8 ef f4 ff ff       	call   801019ac <idup>
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801024c3:	e9 9e 00 00 00       	jmp    80102566 <namex+0xe2>
    ilock(ip);
801024c8:	83 ec 0c             	sub    $0xc,%esp
801024cb:	ff 75 f4             	pushl  -0xc(%ebp)
801024ce:	e8 13 f5 ff ff       	call   801019e6 <ilock>
801024d3:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024d9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801024dd:	66 83 f8 01          	cmp    $0x1,%ax
801024e1:	74 18                	je     801024fb <namex+0x77>
      iunlockput(ip);
801024e3:	83 ec 0c             	sub    $0xc,%esp
801024e6:	ff 75 f4             	pushl  -0xc(%ebp)
801024e9:	e8 b8 f7 ff ff       	call   80101ca6 <iunlockput>
801024ee:	83 c4 10             	add    $0x10,%esp
      return 0;
801024f1:	b8 00 00 00 00       	mov    $0x0,%eax
801024f6:	e9 a7 00 00 00       	jmp    801025a2 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
801024fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024ff:	74 20                	je     80102521 <namex+0x9d>
80102501:	8b 45 08             	mov    0x8(%ebp),%eax
80102504:	0f b6 00             	movzbl (%eax),%eax
80102507:	84 c0                	test   %al,%al
80102509:	75 16                	jne    80102521 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
8010250b:	83 ec 0c             	sub    $0xc,%esp
8010250e:	ff 75 f4             	pushl  -0xc(%ebp)
80102511:	e8 2e f6 ff ff       	call   80101b44 <iunlock>
80102516:	83 c4 10             	add    $0x10,%esp
      return ip;
80102519:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010251c:	e9 81 00 00 00       	jmp    801025a2 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102521:	83 ec 04             	sub    $0x4,%esp
80102524:	6a 00                	push   $0x0
80102526:	ff 75 10             	pushl  0x10(%ebp)
80102529:	ff 75 f4             	pushl  -0xc(%ebp)
8010252c:	e8 1d fd ff ff       	call   8010224e <dirlookup>
80102531:	83 c4 10             	add    $0x10,%esp
80102534:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102537:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010253b:	75 15                	jne    80102552 <namex+0xce>
      iunlockput(ip);
8010253d:	83 ec 0c             	sub    $0xc,%esp
80102540:	ff 75 f4             	pushl  -0xc(%ebp)
80102543:	e8 5e f7 ff ff       	call   80101ca6 <iunlockput>
80102548:	83 c4 10             	add    $0x10,%esp
      return 0;
8010254b:	b8 00 00 00 00       	mov    $0x0,%eax
80102550:	eb 50                	jmp    801025a2 <namex+0x11e>
    }
    iunlockput(ip);
80102552:	83 ec 0c             	sub    $0xc,%esp
80102555:	ff 75 f4             	pushl  -0xc(%ebp)
80102558:	e8 49 f7 ff ff       	call   80101ca6 <iunlockput>
8010255d:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102560:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102563:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
80102566:	83 ec 08             	sub    $0x8,%esp
80102569:	ff 75 10             	pushl  0x10(%ebp)
8010256c:	ff 75 08             	pushl  0x8(%ebp)
8010256f:	e8 6c fe ff ff       	call   801023e0 <skipelem>
80102574:	83 c4 10             	add    $0x10,%esp
80102577:	89 45 08             	mov    %eax,0x8(%ebp)
8010257a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010257e:	0f 85 44 ff ff ff    	jne    801024c8 <namex+0x44>
  }
  if(nameiparent){
80102584:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102588:	74 15                	je     8010259f <namex+0x11b>
    iput(ip);
8010258a:	83 ec 0c             	sub    $0xc,%esp
8010258d:	ff 75 f4             	pushl  -0xc(%ebp)
80102590:	e8 21 f6 ff ff       	call   80101bb6 <iput>
80102595:	83 c4 10             	add    $0x10,%esp
    return 0;
80102598:	b8 00 00 00 00       	mov    $0x0,%eax
8010259d:	eb 03                	jmp    801025a2 <namex+0x11e>
  }
  return ip;
8010259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801025a2:	c9                   	leave  
801025a3:	c3                   	ret    

801025a4 <namei>:

struct inode*
namei(char *path)
{
801025a4:	55                   	push   %ebp
801025a5:	89 e5                	mov    %esp,%ebp
801025a7:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025aa:	83 ec 04             	sub    $0x4,%esp
801025ad:	8d 45 ea             	lea    -0x16(%ebp),%eax
801025b0:	50                   	push   %eax
801025b1:	6a 00                	push   $0x0
801025b3:	ff 75 08             	pushl  0x8(%ebp)
801025b6:	e8 c9 fe ff ff       	call   80102484 <namex>
801025bb:	83 c4 10             	add    $0x10,%esp
}
801025be:	c9                   	leave  
801025bf:	c3                   	ret    

801025c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801025c6:	83 ec 04             	sub    $0x4,%esp
801025c9:	ff 75 0c             	pushl  0xc(%ebp)
801025cc:	6a 01                	push   $0x1
801025ce:	ff 75 08             	pushl  0x8(%ebp)
801025d1:	e8 ae fe ff ff       	call   80102484 <namex>
801025d6:	83 c4 10             	add    $0x10,%esp
}
801025d9:	c9                   	leave  
801025da:	c3                   	ret    

801025db <inb>:
{
801025db:	55                   	push   %ebp
801025dc:	89 e5                	mov    %esp,%ebp
801025de:	83 ec 14             	sub    $0x14,%esp
801025e1:	8b 45 08             	mov    0x8(%ebp),%eax
801025e4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801025ec:	89 c2                	mov    %eax,%edx
801025ee:	ec                   	in     (%dx),%al
801025ef:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801025f2:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801025f6:	c9                   	leave  
801025f7:	c3                   	ret    

801025f8 <insl>:
{
801025f8:	55                   	push   %ebp
801025f9:	89 e5                	mov    %esp,%ebp
801025fb:	57                   	push   %edi
801025fc:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025fd:	8b 55 08             	mov    0x8(%ebp),%edx
80102600:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102603:	8b 45 10             	mov    0x10(%ebp),%eax
80102606:	89 cb                	mov    %ecx,%ebx
80102608:	89 df                	mov    %ebx,%edi
8010260a:	89 c1                	mov    %eax,%ecx
8010260c:	fc                   	cld    
8010260d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010260f:	89 c8                	mov    %ecx,%eax
80102611:	89 fb                	mov    %edi,%ebx
80102613:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102616:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102619:	90                   	nop
8010261a:	5b                   	pop    %ebx
8010261b:	5f                   	pop    %edi
8010261c:	5d                   	pop    %ebp
8010261d:	c3                   	ret    

8010261e <outb>:
{
8010261e:	55                   	push   %ebp
8010261f:	89 e5                	mov    %esp,%ebp
80102621:	83 ec 08             	sub    $0x8,%esp
80102624:	8b 55 08             	mov    0x8(%ebp),%edx
80102627:	8b 45 0c             	mov    0xc(%ebp),%eax
8010262a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010262e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102631:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102635:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102639:	ee                   	out    %al,(%dx)
}
8010263a:	90                   	nop
8010263b:	c9                   	leave  
8010263c:	c3                   	ret    

8010263d <outsl>:
{
8010263d:	55                   	push   %ebp
8010263e:	89 e5                	mov    %esp,%ebp
80102640:	56                   	push   %esi
80102641:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102642:	8b 55 08             	mov    0x8(%ebp),%edx
80102645:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102648:	8b 45 10             	mov    0x10(%ebp),%eax
8010264b:	89 cb                	mov    %ecx,%ebx
8010264d:	89 de                	mov    %ebx,%esi
8010264f:	89 c1                	mov    %eax,%ecx
80102651:	fc                   	cld    
80102652:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102654:	89 c8                	mov    %ecx,%eax
80102656:	89 f3                	mov    %esi,%ebx
80102658:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010265b:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010265e:	90                   	nop
8010265f:	5b                   	pop    %ebx
80102660:	5e                   	pop    %esi
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    

80102663 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102663:	55                   	push   %ebp
80102664:	89 e5                	mov    %esp,%ebp
80102666:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102669:	90                   	nop
8010266a:	68 f7 01 00 00       	push   $0x1f7
8010266f:	e8 67 ff ff ff       	call   801025db <inb>
80102674:	83 c4 04             	add    $0x4,%esp
80102677:	0f b6 c0             	movzbl %al,%eax
8010267a:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010267d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102680:	25 c0 00 00 00       	and    $0xc0,%eax
80102685:	83 f8 40             	cmp    $0x40,%eax
80102688:	75 e0                	jne    8010266a <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010268a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010268e:	74 11                	je     801026a1 <idewait+0x3e>
80102690:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102693:	83 e0 21             	and    $0x21,%eax
80102696:	85 c0                	test   %eax,%eax
80102698:	74 07                	je     801026a1 <idewait+0x3e>
    return -1;
8010269a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010269f:	eb 05                	jmp    801026a6 <idewait+0x43>
  return 0;
801026a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801026a6:	c9                   	leave  
801026a7:	c3                   	ret    

801026a8 <ideinit>:

void
ideinit(void)
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801026ae:	83 ec 08             	sub    $0x8,%esp
801026b1:	68 2e 8b 10 80       	push   $0x80108b2e
801026b6:	68 20 c6 10 80       	push   $0x8010c620
801026bb:	e8 cc 2a 00 00       	call   8010518c <initlock>
801026c0:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026c3:	83 ec 0c             	sub    $0xc,%esp
801026c6:	6a 0e                	push   $0xe
801026c8:	e8 2d 19 00 00       	call   80103ffa <picenable>
801026cd:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026d0:	a1 20 43 11 80       	mov    0x80114320,%eax
801026d5:	83 e8 01             	sub    $0x1,%eax
801026d8:	83 ec 08             	sub    $0x8,%esp
801026db:	50                   	push   %eax
801026dc:	6a 0e                	push   $0xe
801026de:	e8 73 04 00 00       	call   80102b56 <ioapicenable>
801026e3:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801026e6:	83 ec 0c             	sub    $0xc,%esp
801026e9:	6a 00                	push   $0x0
801026eb:	e8 73 ff ff ff       	call   80102663 <idewait>
801026f0:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801026f3:	83 ec 08             	sub    $0x8,%esp
801026f6:	68 f0 00 00 00       	push   $0xf0
801026fb:	68 f6 01 00 00       	push   $0x1f6
80102700:	e8 19 ff ff ff       	call   8010261e <outb>
80102705:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102708:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010270f:	eb 24                	jmp    80102735 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102711:	83 ec 0c             	sub    $0xc,%esp
80102714:	68 f7 01 00 00       	push   $0x1f7
80102719:	e8 bd fe ff ff       	call   801025db <inb>
8010271e:	83 c4 10             	add    $0x10,%esp
80102721:	84 c0                	test   %al,%al
80102723:	74 0c                	je     80102731 <ideinit+0x89>
      havedisk1 = 1;
80102725:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
8010272c:	00 00 00 
      break;
8010272f:	eb 0d                	jmp    8010273e <ideinit+0x96>
  for(i=0; i<1000; i++){
80102731:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102735:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010273c:	7e d3                	jle    80102711 <ideinit+0x69>
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010273e:	83 ec 08             	sub    $0x8,%esp
80102741:	68 e0 00 00 00       	push   $0xe0
80102746:	68 f6 01 00 00       	push   $0x1f6
8010274b:	e8 ce fe ff ff       	call   8010261e <outb>
80102750:	83 c4 10             	add    $0x10,%esp
}
80102753:	90                   	nop
80102754:	c9                   	leave  
80102755:	c3                   	ret    

80102756 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102756:	55                   	push   %ebp
80102757:	89 e5                	mov    %esp,%ebp
80102759:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010275c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102760:	75 0d                	jne    8010276f <idestart+0x19>
    panic("idestart");
80102762:	83 ec 0c             	sub    $0xc,%esp
80102765:	68 32 8b 10 80       	push   $0x80108b32
8010276a:	e8 73 de ff ff       	call   801005e2 <panic>
  if(b->blockno >= FSSIZE)
8010276f:	8b 45 08             	mov    0x8(%ebp),%eax
80102772:	8b 40 08             	mov    0x8(%eax),%eax
80102775:	3d e7 03 00 00       	cmp    $0x3e7,%eax
8010277a:	76 0d                	jbe    80102789 <idestart+0x33>
    panic("incorrect blockno");
8010277c:	83 ec 0c             	sub    $0xc,%esp
8010277f:	68 3b 8b 10 80       	push   $0x80108b3b
80102784:	e8 59 de ff ff       	call   801005e2 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102789:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102790:	8b 45 08             	mov    0x8(%ebp),%eax
80102793:	8b 50 08             	mov    0x8(%eax),%edx
80102796:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102799:	0f af c2             	imul   %edx,%eax
8010279c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
8010279f:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801027a3:	7e 0d                	jle    801027b2 <idestart+0x5c>
801027a5:	83 ec 0c             	sub    $0xc,%esp
801027a8:	68 32 8b 10 80       	push   $0x80108b32
801027ad:	e8 30 de ff ff       	call   801005e2 <panic>
  
  idewait(0);
801027b2:	83 ec 0c             	sub    $0xc,%esp
801027b5:	6a 00                	push   $0x0
801027b7:	e8 a7 fe ff ff       	call   80102663 <idewait>
801027bc:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801027bf:	83 ec 08             	sub    $0x8,%esp
801027c2:	6a 00                	push   $0x0
801027c4:	68 f6 03 00 00       	push   $0x3f6
801027c9:	e8 50 fe ff ff       	call   8010261e <outb>
801027ce:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d4:	0f b6 c0             	movzbl %al,%eax
801027d7:	83 ec 08             	sub    $0x8,%esp
801027da:	50                   	push   %eax
801027db:	68 f2 01 00 00       	push   $0x1f2
801027e0:	e8 39 fe ff ff       	call   8010261e <outb>
801027e5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801027e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027eb:	0f b6 c0             	movzbl %al,%eax
801027ee:	83 ec 08             	sub    $0x8,%esp
801027f1:	50                   	push   %eax
801027f2:	68 f3 01 00 00       	push   $0x1f3
801027f7:	e8 22 fe ff ff       	call   8010261e <outb>
801027fc:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801027ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102802:	c1 f8 08             	sar    $0x8,%eax
80102805:	0f b6 c0             	movzbl %al,%eax
80102808:	83 ec 08             	sub    $0x8,%esp
8010280b:	50                   	push   %eax
8010280c:	68 f4 01 00 00       	push   $0x1f4
80102811:	e8 08 fe ff ff       	call   8010261e <outb>
80102816:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102819:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010281c:	c1 f8 10             	sar    $0x10,%eax
8010281f:	0f b6 c0             	movzbl %al,%eax
80102822:	83 ec 08             	sub    $0x8,%esp
80102825:	50                   	push   %eax
80102826:	68 f5 01 00 00       	push   $0x1f5
8010282b:	e8 ee fd ff ff       	call   8010261e <outb>
80102830:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102833:	8b 45 08             	mov    0x8(%ebp),%eax
80102836:	8b 40 04             	mov    0x4(%eax),%eax
80102839:	c1 e0 04             	shl    $0x4,%eax
8010283c:	83 e0 10             	and    $0x10,%eax
8010283f:	89 c2                	mov    %eax,%edx
80102841:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102844:	c1 f8 18             	sar    $0x18,%eax
80102847:	83 e0 0f             	and    $0xf,%eax
8010284a:	09 d0                	or     %edx,%eax
8010284c:	83 c8 e0             	or     $0xffffffe0,%eax
8010284f:	0f b6 c0             	movzbl %al,%eax
80102852:	83 ec 08             	sub    $0x8,%esp
80102855:	50                   	push   %eax
80102856:	68 f6 01 00 00       	push   $0x1f6
8010285b:	e8 be fd ff ff       	call   8010261e <outb>
80102860:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102863:	8b 45 08             	mov    0x8(%ebp),%eax
80102866:	8b 00                	mov    (%eax),%eax
80102868:	83 e0 04             	and    $0x4,%eax
8010286b:	85 c0                	test   %eax,%eax
8010286d:	74 30                	je     8010289f <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
8010286f:	83 ec 08             	sub    $0x8,%esp
80102872:	6a 30                	push   $0x30
80102874:	68 f7 01 00 00       	push   $0x1f7
80102879:	e8 a0 fd ff ff       	call   8010261e <outb>
8010287e:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102881:	8b 45 08             	mov    0x8(%ebp),%eax
80102884:	83 c0 18             	add    $0x18,%eax
80102887:	83 ec 04             	sub    $0x4,%esp
8010288a:	68 80 00 00 00       	push   $0x80
8010288f:	50                   	push   %eax
80102890:	68 f0 01 00 00       	push   $0x1f0
80102895:	e8 a3 fd ff ff       	call   8010263d <outsl>
8010289a:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
8010289d:	eb 12                	jmp    801028b1 <idestart+0x15b>
    outb(0x1f7, IDE_CMD_READ);
8010289f:	83 ec 08             	sub    $0x8,%esp
801028a2:	6a 20                	push   $0x20
801028a4:	68 f7 01 00 00       	push   $0x1f7
801028a9:	e8 70 fd ff ff       	call   8010261e <outb>
801028ae:	83 c4 10             	add    $0x10,%esp
}
801028b1:	90                   	nop
801028b2:	c9                   	leave  
801028b3:	c3                   	ret    

801028b4 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028b4:	55                   	push   %ebp
801028b5:	89 e5                	mov    %esp,%ebp
801028b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028ba:	83 ec 0c             	sub    $0xc,%esp
801028bd:	68 20 c6 10 80       	push   $0x8010c620
801028c2:	e8 e7 28 00 00       	call   801051ae <acquire>
801028c7:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028ca:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028d6:	75 15                	jne    801028ed <ideintr+0x39>
    release(&idelock);
801028d8:	83 ec 0c             	sub    $0xc,%esp
801028db:	68 20 c6 10 80       	push   $0x8010c620
801028e0:	e8 30 29 00 00       	call   80105215 <release>
801028e5:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801028e8:	e9 9a 00 00 00       	jmp    80102987 <ideintr+0xd3>
  }
  idequeue = b->qnext;
801028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f0:	8b 40 14             	mov    0x14(%eax),%eax
801028f3:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028fb:	8b 00                	mov    (%eax),%eax
801028fd:	83 e0 04             	and    $0x4,%eax
80102900:	85 c0                	test   %eax,%eax
80102902:	75 2d                	jne    80102931 <ideintr+0x7d>
80102904:	83 ec 0c             	sub    $0xc,%esp
80102907:	6a 01                	push   $0x1
80102909:	e8 55 fd ff ff       	call   80102663 <idewait>
8010290e:	83 c4 10             	add    $0x10,%esp
80102911:	85 c0                	test   %eax,%eax
80102913:	78 1c                	js     80102931 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102915:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102918:	83 c0 18             	add    $0x18,%eax
8010291b:	83 ec 04             	sub    $0x4,%esp
8010291e:	68 80 00 00 00       	push   $0x80
80102923:	50                   	push   %eax
80102924:	68 f0 01 00 00       	push   $0x1f0
80102929:	e8 ca fc ff ff       	call   801025f8 <insl>
8010292e:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102931:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102934:	8b 00                	mov    (%eax),%eax
80102936:	83 c8 02             	or     $0x2,%eax
80102939:	89 c2                	mov    %eax,%edx
8010293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010293e:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102943:	8b 00                	mov    (%eax),%eax
80102945:	83 e0 fb             	and    $0xfffffffb,%eax
80102948:	89 c2                	mov    %eax,%edx
8010294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294d:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010294f:	83 ec 0c             	sub    $0xc,%esp
80102952:	ff 75 f4             	pushl  -0xc(%ebp)
80102955:	e8 46 26 00 00       	call   80104fa0 <wakeup>
8010295a:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010295d:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102962:	85 c0                	test   %eax,%eax
80102964:	74 11                	je     80102977 <ideintr+0xc3>
    idestart(idequeue);
80102966:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010296b:	83 ec 0c             	sub    $0xc,%esp
8010296e:	50                   	push   %eax
8010296f:	e8 e2 fd ff ff       	call   80102756 <idestart>
80102974:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102977:	83 ec 0c             	sub    $0xc,%esp
8010297a:	68 20 c6 10 80       	push   $0x8010c620
8010297f:	e8 91 28 00 00       	call   80105215 <release>
80102984:	83 c4 10             	add    $0x10,%esp
}
80102987:	c9                   	leave  
80102988:	c3                   	ret    

80102989 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102989:	55                   	push   %ebp
8010298a:	89 e5                	mov    %esp,%ebp
8010298c:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010298f:	8b 45 08             	mov    0x8(%ebp),%eax
80102992:	8b 00                	mov    (%eax),%eax
80102994:	83 e0 01             	and    $0x1,%eax
80102997:	85 c0                	test   %eax,%eax
80102999:	75 0d                	jne    801029a8 <iderw+0x1f>
    panic("iderw: buf not busy");
8010299b:	83 ec 0c             	sub    $0xc,%esp
8010299e:	68 4d 8b 10 80       	push   $0x80108b4d
801029a3:	e8 3a dc ff ff       	call   801005e2 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029a8:	8b 45 08             	mov    0x8(%ebp),%eax
801029ab:	8b 00                	mov    (%eax),%eax
801029ad:	83 e0 06             	and    $0x6,%eax
801029b0:	83 f8 02             	cmp    $0x2,%eax
801029b3:	75 0d                	jne    801029c2 <iderw+0x39>
    panic("iderw: nothing to do");
801029b5:	83 ec 0c             	sub    $0xc,%esp
801029b8:	68 61 8b 10 80       	push   $0x80108b61
801029bd:	e8 20 dc ff ff       	call   801005e2 <panic>
  if(b->dev != 0 && !havedisk1)
801029c2:	8b 45 08             	mov    0x8(%ebp),%eax
801029c5:	8b 40 04             	mov    0x4(%eax),%eax
801029c8:	85 c0                	test   %eax,%eax
801029ca:	74 16                	je     801029e2 <iderw+0x59>
801029cc:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801029d1:	85 c0                	test   %eax,%eax
801029d3:	75 0d                	jne    801029e2 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801029d5:	83 ec 0c             	sub    $0xc,%esp
801029d8:	68 76 8b 10 80       	push   $0x80108b76
801029dd:	e8 00 dc ff ff       	call   801005e2 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029e2:	83 ec 0c             	sub    $0xc,%esp
801029e5:	68 20 c6 10 80       	push   $0x8010c620
801029ea:	e8 bf 27 00 00       	call   801051ae <acquire>
801029ef:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801029f2:	8b 45 08             	mov    0x8(%ebp),%eax
801029f5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029fc:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
80102a03:	eb 0b                	jmp    80102a10 <iderw+0x87>
80102a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a08:	8b 00                	mov    (%eax),%eax
80102a0a:	83 c0 14             	add    $0x14,%eax
80102a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a13:	8b 00                	mov    (%eax),%eax
80102a15:	85 c0                	test   %eax,%eax
80102a17:	75 ec                	jne    80102a05 <iderw+0x7c>
    ;
  *pp = b;
80102a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a1c:	8b 55 08             	mov    0x8(%ebp),%edx
80102a1f:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102a21:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102a26:	3b 45 08             	cmp    0x8(%ebp),%eax
80102a29:	75 23                	jne    80102a4e <iderw+0xc5>
    idestart(b);
80102a2b:	83 ec 0c             	sub    $0xc,%esp
80102a2e:	ff 75 08             	pushl  0x8(%ebp)
80102a31:	e8 20 fd ff ff       	call   80102756 <idestart>
80102a36:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a39:	eb 13                	jmp    80102a4e <iderw+0xc5>
    sleep(b, &idelock);
80102a3b:	83 ec 08             	sub    $0x8,%esp
80102a3e:	68 20 c6 10 80       	push   $0x8010c620
80102a43:	ff 75 08             	pushl  0x8(%ebp)
80102a46:	e8 6a 24 00 00       	call   80104eb5 <sleep>
80102a4b:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a4e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a51:	8b 00                	mov    (%eax),%eax
80102a53:	83 e0 06             	and    $0x6,%eax
80102a56:	83 f8 02             	cmp    $0x2,%eax
80102a59:	75 e0                	jne    80102a3b <iderw+0xb2>
  }

  release(&idelock);
80102a5b:	83 ec 0c             	sub    $0xc,%esp
80102a5e:	68 20 c6 10 80       	push   $0x8010c620
80102a63:	e8 ad 27 00 00       	call   80105215 <release>
80102a68:	83 c4 10             	add    $0x10,%esp
}
80102a6b:	90                   	nop
80102a6c:	c9                   	leave  
80102a6d:	c3                   	ret    

80102a6e <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a6e:	55                   	push   %ebp
80102a6f:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a71:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
80102a76:	8b 55 08             	mov    0x8(%ebp),%edx
80102a79:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a7b:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
80102a80:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a83:	5d                   	pop    %ebp
80102a84:	c3                   	ret    

80102a85 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a85:	55                   	push   %ebp
80102a86:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a88:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
80102a8d:	8b 55 08             	mov    0x8(%ebp),%edx
80102a90:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a92:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
80102a97:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a9a:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a9d:	90                   	nop
80102a9e:	5d                   	pop    %ebp
80102a9f:	c3                   	ret    

80102aa0 <ioapicinit>:

void
ioapicinit(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102aa6:	a1 24 3d 11 80       	mov    0x80113d24,%eax
80102aab:	85 c0                	test   %eax,%eax
80102aad:	0f 84 a0 00 00 00    	je     80102b53 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102ab3:	c7 05 f4 3b 11 80 00 	movl   $0xfec00000,0x80113bf4
80102aba:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102abd:	6a 01                	push   $0x1
80102abf:	e8 aa ff ff ff       	call   80102a6e <ioapicread>
80102ac4:	83 c4 04             	add    $0x4,%esp
80102ac7:	c1 e8 10             	shr    $0x10,%eax
80102aca:	25 ff 00 00 00       	and    $0xff,%eax
80102acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102ad2:	6a 00                	push   $0x0
80102ad4:	e8 95 ff ff ff       	call   80102a6e <ioapicread>
80102ad9:	83 c4 04             	add    $0x4,%esp
80102adc:	c1 e8 18             	shr    $0x18,%eax
80102adf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102ae2:	0f b6 05 20 3d 11 80 	movzbl 0x80113d20,%eax
80102ae9:	0f b6 c0             	movzbl %al,%eax
80102aec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102aef:	74 10                	je     80102b01 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102af1:	83 ec 0c             	sub    $0xc,%esp
80102af4:	68 94 8b 10 80       	push   $0x80108b94
80102af9:	e8 1c d9 ff ff       	call   8010041a <cprintf>
80102afe:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b08:	eb 3f                	jmp    80102b49 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b0d:	83 c0 20             	add    $0x20,%eax
80102b10:	0d 00 00 01 00       	or     $0x10000,%eax
80102b15:	89 c2                	mov    %eax,%edx
80102b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1a:	83 c0 08             	add    $0x8,%eax
80102b1d:	01 c0                	add    %eax,%eax
80102b1f:	83 ec 08             	sub    $0x8,%esp
80102b22:	52                   	push   %edx
80102b23:	50                   	push   %eax
80102b24:	e8 5c ff ff ff       	call   80102a85 <ioapicwrite>
80102b29:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2f:	83 c0 08             	add    $0x8,%eax
80102b32:	01 c0                	add    %eax,%eax
80102b34:	83 c0 01             	add    $0x1,%eax
80102b37:	83 ec 08             	sub    $0x8,%esp
80102b3a:	6a 00                	push   $0x0
80102b3c:	50                   	push   %eax
80102b3d:	e8 43 ff ff ff       	call   80102a85 <ioapicwrite>
80102b42:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102b45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b4c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b4f:	7e b9                	jle    80102b0a <ioapicinit+0x6a>
80102b51:	eb 01                	jmp    80102b54 <ioapicinit+0xb4>
    return;
80102b53:	90                   	nop
  }
}
80102b54:	c9                   	leave  
80102b55:	c3                   	ret    

80102b56 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b56:	55                   	push   %ebp
80102b57:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b59:	a1 24 3d 11 80       	mov    0x80113d24,%eax
80102b5e:	85 c0                	test   %eax,%eax
80102b60:	74 39                	je     80102b9b <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b62:	8b 45 08             	mov    0x8(%ebp),%eax
80102b65:	83 c0 20             	add    $0x20,%eax
80102b68:	89 c2                	mov    %eax,%edx
80102b6a:	8b 45 08             	mov    0x8(%ebp),%eax
80102b6d:	83 c0 08             	add    $0x8,%eax
80102b70:	01 c0                	add    %eax,%eax
80102b72:	52                   	push   %edx
80102b73:	50                   	push   %eax
80102b74:	e8 0c ff ff ff       	call   80102a85 <ioapicwrite>
80102b79:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b7f:	c1 e0 18             	shl    $0x18,%eax
80102b82:	89 c2                	mov    %eax,%edx
80102b84:	8b 45 08             	mov    0x8(%ebp),%eax
80102b87:	83 c0 08             	add    $0x8,%eax
80102b8a:	01 c0                	add    %eax,%eax
80102b8c:	83 c0 01             	add    $0x1,%eax
80102b8f:	52                   	push   %edx
80102b90:	50                   	push   %eax
80102b91:	e8 ef fe ff ff       	call   80102a85 <ioapicwrite>
80102b96:	83 c4 08             	add    $0x8,%esp
80102b99:	eb 01                	jmp    80102b9c <ioapicenable+0x46>
    return;
80102b9b:	90                   	nop
}
80102b9c:	c9                   	leave  
80102b9d:	c3                   	ret    

80102b9e <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102b9e:	55                   	push   %ebp
80102b9f:	89 e5                	mov    %esp,%ebp
80102ba1:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba4:	05 00 00 00 80       	add    $0x80000000,%eax
80102ba9:	5d                   	pop    %ebp
80102baa:	c3                   	ret    

80102bab <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102bab:	55                   	push   %ebp
80102bac:	89 e5                	mov    %esp,%ebp
80102bae:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102bb1:	83 ec 08             	sub    $0x8,%esp
80102bb4:	68 c6 8b 10 80       	push   $0x80108bc6
80102bb9:	68 00 3c 11 80       	push   $0x80113c00
80102bbe:	e8 c9 25 00 00       	call   8010518c <initlock>
80102bc3:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102bc6:	c7 05 34 3c 11 80 00 	movl   $0x0,0x80113c34
80102bcd:	00 00 00 
  freerange(vstart, vend);
80102bd0:	83 ec 08             	sub    $0x8,%esp
80102bd3:	ff 75 0c             	pushl  0xc(%ebp)
80102bd6:	ff 75 08             	pushl  0x8(%ebp)
80102bd9:	e8 2a 00 00 00       	call   80102c08 <freerange>
80102bde:	83 c4 10             	add    $0x10,%esp
}
80102be1:	90                   	nop
80102be2:	c9                   	leave  
80102be3:	c3                   	ret    

80102be4 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102be4:	55                   	push   %ebp
80102be5:	89 e5                	mov    %esp,%ebp
80102be7:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102bea:	83 ec 08             	sub    $0x8,%esp
80102bed:	ff 75 0c             	pushl  0xc(%ebp)
80102bf0:	ff 75 08             	pushl  0x8(%ebp)
80102bf3:	e8 10 00 00 00       	call   80102c08 <freerange>
80102bf8:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102bfb:	c7 05 34 3c 11 80 01 	movl   $0x1,0x80113c34
80102c02:	00 00 00 
}
80102c05:	90                   	nop
80102c06:	c9                   	leave  
80102c07:	c3                   	ret    

80102c08 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102c08:	55                   	push   %ebp
80102c09:	89 e5                	mov    %esp,%ebp
80102c0b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80102c11:	05 ff 0f 00 00       	add    $0xfff,%eax
80102c16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c1e:	eb 15                	jmp    80102c35 <freerange+0x2d>
    kfree(p);
80102c20:	83 ec 0c             	sub    $0xc,%esp
80102c23:	ff 75 f4             	pushl  -0xc(%ebp)
80102c26:	e8 1a 00 00 00       	call   80102c45 <kfree>
80102c2b:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c2e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c38:	05 00 10 00 00       	add    $0x1000,%eax
80102c3d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102c40:	76 de                	jbe    80102c20 <freerange+0x18>
}
80102c42:	90                   	nop
80102c43:	c9                   	leave  
80102c44:	c3                   	ret    

80102c45 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c45:	55                   	push   %ebp
80102c46:	89 e5                	mov    %esp,%ebp
80102c48:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80102c4e:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c53:	85 c0                	test   %eax,%eax
80102c55:	75 1b                	jne    80102c72 <kfree+0x2d>
80102c57:	81 7d 08 3c 6c 11 80 	cmpl   $0x80116c3c,0x8(%ebp)
80102c5e:	72 12                	jb     80102c72 <kfree+0x2d>
80102c60:	ff 75 08             	pushl  0x8(%ebp)
80102c63:	e8 36 ff ff ff       	call   80102b9e <v2p>
80102c68:	83 c4 04             	add    $0x4,%esp
80102c6b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c70:	76 0d                	jbe    80102c7f <kfree+0x3a>
    panic("kfree");
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	68 cb 8b 10 80       	push   $0x80108bcb
80102c7a:	e8 63 d9 ff ff       	call   801005e2 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c7f:	83 ec 04             	sub    $0x4,%esp
80102c82:	68 00 10 00 00       	push   $0x1000
80102c87:	6a 01                	push   $0x1
80102c89:	ff 75 08             	pushl  0x8(%ebp)
80102c8c:	e8 80 27 00 00       	call   80105411 <memset>
80102c91:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c94:	a1 34 3c 11 80       	mov    0x80113c34,%eax
80102c99:	85 c0                	test   %eax,%eax
80102c9b:	74 10                	je     80102cad <kfree+0x68>
    acquire(&kmem.lock);
80102c9d:	83 ec 0c             	sub    $0xc,%esp
80102ca0:	68 00 3c 11 80       	push   $0x80113c00
80102ca5:	e8 04 25 00 00       	call   801051ae <acquire>
80102caa:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102cad:	8b 45 08             	mov    0x8(%ebp),%eax
80102cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102cb3:	8b 15 38 3c 11 80    	mov    0x80113c38,%edx
80102cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cbc:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc1:	a3 38 3c 11 80       	mov    %eax,0x80113c38
  if(kmem.use_lock)
80102cc6:	a1 34 3c 11 80       	mov    0x80113c34,%eax
80102ccb:	85 c0                	test   %eax,%eax
80102ccd:	74 10                	je     80102cdf <kfree+0x9a>
    release(&kmem.lock);
80102ccf:	83 ec 0c             	sub    $0xc,%esp
80102cd2:	68 00 3c 11 80       	push   $0x80113c00
80102cd7:	e8 39 25 00 00       	call   80105215 <release>
80102cdc:	83 c4 10             	add    $0x10,%esp
}
80102cdf:	90                   	nop
80102ce0:	c9                   	leave  
80102ce1:	c3                   	ret    

80102ce2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ce2:	55                   	push   %ebp
80102ce3:	89 e5                	mov    %esp,%ebp
80102ce5:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102ce8:	a1 34 3c 11 80       	mov    0x80113c34,%eax
80102ced:	85 c0                	test   %eax,%eax
80102cef:	74 10                	je     80102d01 <kalloc+0x1f>
    acquire(&kmem.lock);
80102cf1:	83 ec 0c             	sub    $0xc,%esp
80102cf4:	68 00 3c 11 80       	push   $0x80113c00
80102cf9:	e8 b0 24 00 00       	call   801051ae <acquire>
80102cfe:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d01:	a1 38 3c 11 80       	mov    0x80113c38,%eax
80102d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d0d:	74 0a                	je     80102d19 <kalloc+0x37>
    kmem.freelist = r->next;
80102d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d12:	8b 00                	mov    (%eax),%eax
80102d14:	a3 38 3c 11 80       	mov    %eax,0x80113c38
  if(kmem.use_lock)
80102d19:	a1 34 3c 11 80       	mov    0x80113c34,%eax
80102d1e:	85 c0                	test   %eax,%eax
80102d20:	74 10                	je     80102d32 <kalloc+0x50>
    release(&kmem.lock);
80102d22:	83 ec 0c             	sub    $0xc,%esp
80102d25:	68 00 3c 11 80       	push   $0x80113c00
80102d2a:	e8 e6 24 00 00       	call   80105215 <release>
80102d2f:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    

80102d37 <inb>:
{
80102d37:	55                   	push   %ebp
80102d38:	89 e5                	mov    %esp,%ebp
80102d3a:	83 ec 14             	sub    $0x14,%esp
80102d3d:	8b 45 08             	mov    0x8(%ebp),%eax
80102d40:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d44:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d48:	89 c2                	mov    %eax,%edx
80102d4a:	ec                   	in     (%dx),%al
80102d4b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d4e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d52:	c9                   	leave  
80102d53:	c3                   	ret    

80102d54 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d54:	55                   	push   %ebp
80102d55:	89 e5                	mov    %esp,%ebp
80102d57:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d5a:	6a 64                	push   $0x64
80102d5c:	e8 d6 ff ff ff       	call   80102d37 <inb>
80102d61:	83 c4 04             	add    $0x4,%esp
80102d64:	0f b6 c0             	movzbl %al,%eax
80102d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d6d:	83 e0 01             	and    $0x1,%eax
80102d70:	85 c0                	test   %eax,%eax
80102d72:	75 0a                	jne    80102d7e <kbdgetc+0x2a>
    return -1;
80102d74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d79:	e9 23 01 00 00       	jmp    80102ea1 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d7e:	6a 60                	push   $0x60
80102d80:	e8 b2 ff ff ff       	call   80102d37 <inb>
80102d85:	83 c4 04             	add    $0x4,%esp
80102d88:	0f b6 c0             	movzbl %al,%eax
80102d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d8e:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d95:	75 17                	jne    80102dae <kbdgetc+0x5a>
    shift |= E0ESC;
80102d97:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d9c:	83 c8 40             	or     $0x40,%eax
80102d9f:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102da4:	b8 00 00 00 00       	mov    $0x0,%eax
80102da9:	e9 f3 00 00 00       	jmp    80102ea1 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102dae:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102db1:	25 80 00 00 00       	and    $0x80,%eax
80102db6:	85 c0                	test   %eax,%eax
80102db8:	74 45                	je     80102dff <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102dba:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dbf:	83 e0 40             	and    $0x40,%eax
80102dc2:	85 c0                	test   %eax,%eax
80102dc4:	75 08                	jne    80102dce <kbdgetc+0x7a>
80102dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dc9:	83 e0 7f             	and    $0x7f,%eax
80102dcc:	eb 03                	jmp    80102dd1 <kbdgetc+0x7d>
80102dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd7:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102ddc:	0f b6 00             	movzbl (%eax),%eax
80102ddf:	83 c8 40             	or     $0x40,%eax
80102de2:	0f b6 c0             	movzbl %al,%eax
80102de5:	f7 d0                	not    %eax
80102de7:	89 c2                	mov    %eax,%edx
80102de9:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dee:	21 d0                	and    %edx,%eax
80102df0:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102df5:	b8 00 00 00 00       	mov    $0x0,%eax
80102dfa:	e9 a2 00 00 00       	jmp    80102ea1 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102dff:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e04:	83 e0 40             	and    $0x40,%eax
80102e07:	85 c0                	test   %eax,%eax
80102e09:	74 14                	je     80102e1f <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e0b:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e12:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e17:	83 e0 bf             	and    $0xffffffbf,%eax
80102e1a:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102e1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e22:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e27:	0f b6 00             	movzbl (%eax),%eax
80102e2a:	0f b6 d0             	movzbl %al,%edx
80102e2d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e32:	09 d0                	or     %edx,%eax
80102e34:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102e39:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e3c:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102e41:	0f b6 00             	movzbl (%eax),%eax
80102e44:	0f b6 d0             	movzbl %al,%edx
80102e47:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e4c:	31 d0                	xor    %edx,%eax
80102e4e:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e53:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e58:	83 e0 03             	and    $0x3,%eax
80102e5b:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e65:	01 d0                	add    %edx,%eax
80102e67:	0f b6 00             	movzbl (%eax),%eax
80102e6a:	0f b6 c0             	movzbl %al,%eax
80102e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e70:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e75:	83 e0 08             	and    $0x8,%eax
80102e78:	85 c0                	test   %eax,%eax
80102e7a:	74 22                	je     80102e9e <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e7c:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e80:	76 0c                	jbe    80102e8e <kbdgetc+0x13a>
80102e82:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e86:	77 06                	ja     80102e8e <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e88:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e8c:	eb 10                	jmp    80102e9e <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e8e:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e92:	76 0a                	jbe    80102e9e <kbdgetc+0x14a>
80102e94:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e98:	77 04                	ja     80102e9e <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e9a:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ea1:	c9                   	leave  
80102ea2:	c3                   	ret    

80102ea3 <kbdintr>:

void
kbdintr(void)
{
80102ea3:	55                   	push   %ebp
80102ea4:	89 e5                	mov    %esp,%ebp
80102ea6:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102ea9:	83 ec 0c             	sub    $0xc,%esp
80102eac:	68 54 2d 10 80       	push   $0x80102d54
80102eb1:	e8 bf d9 ff ff       	call   80100875 <consoleintr>
80102eb6:	83 c4 10             	add    $0x10,%esp
}
80102eb9:	90                   	nop
80102eba:	c9                   	leave  
80102ebb:	c3                   	ret    

80102ebc <inb>:
{
80102ebc:	55                   	push   %ebp
80102ebd:	89 e5                	mov    %esp,%ebp
80102ebf:	83 ec 14             	sub    $0x14,%esp
80102ec2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ec5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ecd:	89 c2                	mov    %eax,%edx
80102ecf:	ec                   	in     (%dx),%al
80102ed0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ed3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ed7:	c9                   	leave  
80102ed8:	c3                   	ret    

80102ed9 <outb>:
{
80102ed9:	55                   	push   %ebp
80102eda:	89 e5                	mov    %esp,%ebp
80102edc:	83 ec 08             	sub    $0x8,%esp
80102edf:	8b 55 08             	mov    0x8(%ebp),%edx
80102ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ee5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102ee9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eec:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102ef0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102ef4:	ee                   	out    %al,(%dx)
}
80102ef5:	90                   	nop
80102ef6:	c9                   	leave  
80102ef7:	c3                   	ret    

80102ef8 <readeflags>:
{
80102ef8:	55                   	push   %ebp
80102ef9:	89 e5                	mov    %esp,%ebp
80102efb:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102efe:	9c                   	pushf  
80102eff:	58                   	pop    %eax
80102f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102f06:	c9                   	leave  
80102f07:	c3                   	ret    

80102f08 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102f08:	55                   	push   %ebp
80102f09:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102f0b:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80102f10:	8b 55 08             	mov    0x8(%ebp),%edx
80102f13:	c1 e2 02             	shl    $0x2,%edx
80102f16:	01 c2                	add    %eax,%edx
80102f18:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f1b:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f1d:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80102f22:	83 c0 20             	add    $0x20,%eax
80102f25:	8b 00                	mov    (%eax),%eax
}
80102f27:	90                   	nop
80102f28:	5d                   	pop    %ebp
80102f29:	c3                   	ret    

80102f2a <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102f2a:	55                   	push   %ebp
80102f2b:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102f2d:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80102f32:	85 c0                	test   %eax,%eax
80102f34:	0f 84 0b 01 00 00    	je     80103045 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f3a:	68 3f 01 00 00       	push   $0x13f
80102f3f:	6a 3c                	push   $0x3c
80102f41:	e8 c2 ff ff ff       	call   80102f08 <lapicw>
80102f46:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f49:	6a 0b                	push   $0xb
80102f4b:	68 f8 00 00 00       	push   $0xf8
80102f50:	e8 b3 ff ff ff       	call   80102f08 <lapicw>
80102f55:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f58:	68 20 00 02 00       	push   $0x20020
80102f5d:	68 c8 00 00 00       	push   $0xc8
80102f62:	e8 a1 ff ff ff       	call   80102f08 <lapicw>
80102f67:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102f6a:	68 80 96 98 00       	push   $0x989680
80102f6f:	68 e0 00 00 00       	push   $0xe0
80102f74:	e8 8f ff ff ff       	call   80102f08 <lapicw>
80102f79:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f7c:	68 00 00 01 00       	push   $0x10000
80102f81:	68 d4 00 00 00       	push   $0xd4
80102f86:	e8 7d ff ff ff       	call   80102f08 <lapicw>
80102f8b:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f8e:	68 00 00 01 00       	push   $0x10000
80102f93:	68 d8 00 00 00       	push   $0xd8
80102f98:	e8 6b ff ff ff       	call   80102f08 <lapicw>
80102f9d:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102fa0:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80102fa5:	83 c0 30             	add    $0x30,%eax
80102fa8:	8b 00                	mov    (%eax),%eax
80102faa:	c1 e8 10             	shr    $0x10,%eax
80102fad:	0f b6 c0             	movzbl %al,%eax
80102fb0:	83 f8 03             	cmp    $0x3,%eax
80102fb3:	76 12                	jbe    80102fc7 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102fb5:	68 00 00 01 00       	push   $0x10000
80102fba:	68 d0 00 00 00       	push   $0xd0
80102fbf:	e8 44 ff ff ff       	call   80102f08 <lapicw>
80102fc4:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102fc7:	6a 33                	push   $0x33
80102fc9:	68 dc 00 00 00       	push   $0xdc
80102fce:	e8 35 ff ff ff       	call   80102f08 <lapicw>
80102fd3:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102fd6:	6a 00                	push   $0x0
80102fd8:	68 a0 00 00 00       	push   $0xa0
80102fdd:	e8 26 ff ff ff       	call   80102f08 <lapicw>
80102fe2:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102fe5:	6a 00                	push   $0x0
80102fe7:	68 a0 00 00 00       	push   $0xa0
80102fec:	e8 17 ff ff ff       	call   80102f08 <lapicw>
80102ff1:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ff4:	6a 00                	push   $0x0
80102ff6:	6a 2c                	push   $0x2c
80102ff8:	e8 0b ff ff ff       	call   80102f08 <lapicw>
80102ffd:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103000:	6a 00                	push   $0x0
80103002:	68 c4 00 00 00       	push   $0xc4
80103007:	e8 fc fe ff ff       	call   80102f08 <lapicw>
8010300c:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010300f:	68 00 85 08 00       	push   $0x88500
80103014:	68 c0 00 00 00       	push   $0xc0
80103019:	e8 ea fe ff ff       	call   80102f08 <lapicw>
8010301e:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103021:	90                   	nop
80103022:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80103027:	05 00 03 00 00       	add    $0x300,%eax
8010302c:	8b 00                	mov    (%eax),%eax
8010302e:	25 00 10 00 00       	and    $0x1000,%eax
80103033:	85 c0                	test   %eax,%eax
80103035:	75 eb                	jne    80103022 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103037:	6a 00                	push   $0x0
80103039:	6a 20                	push   $0x20
8010303b:	e8 c8 fe ff ff       	call   80102f08 <lapicw>
80103040:	83 c4 08             	add    $0x8,%esp
80103043:	eb 01                	jmp    80103046 <lapicinit+0x11c>
    return;
80103045:	90                   	nop
}
80103046:	c9                   	leave  
80103047:	c3                   	ret    

80103048 <cpunum>:

int
cpunum(void)
{
80103048:	55                   	push   %ebp
80103049:	89 e5                	mov    %esp,%ebp
8010304b:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010304e:	e8 a5 fe ff ff       	call   80102ef8 <readeflags>
80103053:	25 00 02 00 00       	and    $0x200,%eax
80103058:	85 c0                	test   %eax,%eax
8010305a:	74 26                	je     80103082 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
8010305c:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80103061:	8d 50 01             	lea    0x1(%eax),%edx
80103064:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
8010306a:	85 c0                	test   %eax,%eax
8010306c:	75 14                	jne    80103082 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
8010306e:	8b 45 04             	mov    0x4(%ebp),%eax
80103071:	83 ec 08             	sub    $0x8,%esp
80103074:	50                   	push   %eax
80103075:	68 d4 8b 10 80       	push   $0x80108bd4
8010307a:	e8 9b d3 ff ff       	call   8010041a <cprintf>
8010307f:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103082:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80103087:	85 c0                	test   %eax,%eax
80103089:	74 0f                	je     8010309a <cpunum+0x52>
    return lapic[ID]>>24;
8010308b:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80103090:	83 c0 20             	add    $0x20,%eax
80103093:	8b 00                	mov    (%eax),%eax
80103095:	c1 e8 18             	shr    $0x18,%eax
80103098:	eb 05                	jmp    8010309f <cpunum+0x57>
  return 0;
8010309a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010309f:	c9                   	leave  
801030a0:	c3                   	ret    

801030a1 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801030a1:	55                   	push   %ebp
801030a2:	89 e5                	mov    %esp,%ebp
  if(lapic)
801030a4:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
801030a9:	85 c0                	test   %eax,%eax
801030ab:	74 0c                	je     801030b9 <lapiceoi+0x18>
    lapicw(EOI, 0);
801030ad:	6a 00                	push   $0x0
801030af:	6a 2c                	push   $0x2c
801030b1:	e8 52 fe ff ff       	call   80102f08 <lapicw>
801030b6:	83 c4 08             	add    $0x8,%esp
}
801030b9:	90                   	nop
801030ba:	c9                   	leave  
801030bb:	c3                   	ret    

801030bc <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801030bc:	55                   	push   %ebp
801030bd:	89 e5                	mov    %esp,%ebp
}
801030bf:	90                   	nop
801030c0:	5d                   	pop    %ebp
801030c1:	c3                   	ret    

801030c2 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801030c2:	55                   	push   %ebp
801030c3:	89 e5                	mov    %esp,%ebp
801030c5:	83 ec 14             	sub    $0x14,%esp
801030c8:	8b 45 08             	mov    0x8(%ebp),%eax
801030cb:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801030ce:	6a 0f                	push   $0xf
801030d0:	6a 70                	push   $0x70
801030d2:	e8 02 fe ff ff       	call   80102ed9 <outb>
801030d7:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801030da:	6a 0a                	push   $0xa
801030dc:	6a 71                	push   $0x71
801030de:	e8 f6 fd ff ff       	call   80102ed9 <outb>
801030e3:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801030e6:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801030ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030f0:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801030f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030f8:	83 c0 02             	add    $0x2,%eax
801030fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801030fe:	c1 ea 04             	shr    $0x4,%edx
80103101:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103104:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103108:	c1 e0 18             	shl    $0x18,%eax
8010310b:	50                   	push   %eax
8010310c:	68 c4 00 00 00       	push   $0xc4
80103111:	e8 f2 fd ff ff       	call   80102f08 <lapicw>
80103116:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103119:	68 00 c5 00 00       	push   $0xc500
8010311e:	68 c0 00 00 00       	push   $0xc0
80103123:	e8 e0 fd ff ff       	call   80102f08 <lapicw>
80103128:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010312b:	68 c8 00 00 00       	push   $0xc8
80103130:	e8 87 ff ff ff       	call   801030bc <microdelay>
80103135:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103138:	68 00 85 00 00       	push   $0x8500
8010313d:	68 c0 00 00 00       	push   $0xc0
80103142:	e8 c1 fd ff ff       	call   80102f08 <lapicw>
80103147:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010314a:	6a 64                	push   $0x64
8010314c:	e8 6b ff ff ff       	call   801030bc <microdelay>
80103151:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103154:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010315b:	eb 3d                	jmp    8010319a <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010315d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103161:	c1 e0 18             	shl    $0x18,%eax
80103164:	50                   	push   %eax
80103165:	68 c4 00 00 00       	push   $0xc4
8010316a:	e8 99 fd ff ff       	call   80102f08 <lapicw>
8010316f:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103172:	8b 45 0c             	mov    0xc(%ebp),%eax
80103175:	c1 e8 0c             	shr    $0xc,%eax
80103178:	80 cc 06             	or     $0x6,%ah
8010317b:	50                   	push   %eax
8010317c:	68 c0 00 00 00       	push   $0xc0
80103181:	e8 82 fd ff ff       	call   80102f08 <lapicw>
80103186:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103189:	68 c8 00 00 00       	push   $0xc8
8010318e:	e8 29 ff ff ff       	call   801030bc <microdelay>
80103193:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80103196:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010319a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010319e:	7e bd                	jle    8010315d <lapicstartap+0x9b>
  }
}
801031a0:	90                   	nop
801031a1:	c9                   	leave  
801031a2:	c3                   	ret    

801031a3 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801031a3:	55                   	push   %ebp
801031a4:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801031a6:	8b 45 08             	mov    0x8(%ebp),%eax
801031a9:	0f b6 c0             	movzbl %al,%eax
801031ac:	50                   	push   %eax
801031ad:	6a 70                	push   $0x70
801031af:	e8 25 fd ff ff       	call   80102ed9 <outb>
801031b4:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801031b7:	68 c8 00 00 00       	push   $0xc8
801031bc:	e8 fb fe ff ff       	call   801030bc <microdelay>
801031c1:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801031c4:	6a 71                	push   $0x71
801031c6:	e8 f1 fc ff ff       	call   80102ebc <inb>
801031cb:	83 c4 04             	add    $0x4,%esp
801031ce:	0f b6 c0             	movzbl %al,%eax
}
801031d1:	c9                   	leave  
801031d2:	c3                   	ret    

801031d3 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801031d3:	55                   	push   %ebp
801031d4:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801031d6:	6a 00                	push   $0x0
801031d8:	e8 c6 ff ff ff       	call   801031a3 <cmos_read>
801031dd:	83 c4 04             	add    $0x4,%esp
801031e0:	89 c2                	mov    %eax,%edx
801031e2:	8b 45 08             	mov    0x8(%ebp),%eax
801031e5:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801031e7:	6a 02                	push   $0x2
801031e9:	e8 b5 ff ff ff       	call   801031a3 <cmos_read>
801031ee:	83 c4 04             	add    $0x4,%esp
801031f1:	89 c2                	mov    %eax,%edx
801031f3:	8b 45 08             	mov    0x8(%ebp),%eax
801031f6:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801031f9:	6a 04                	push   $0x4
801031fb:	e8 a3 ff ff ff       	call   801031a3 <cmos_read>
80103200:	83 c4 04             	add    $0x4,%esp
80103203:	89 c2                	mov    %eax,%edx
80103205:	8b 45 08             	mov    0x8(%ebp),%eax
80103208:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
8010320b:	6a 07                	push   $0x7
8010320d:	e8 91 ff ff ff       	call   801031a3 <cmos_read>
80103212:	83 c4 04             	add    $0x4,%esp
80103215:	89 c2                	mov    %eax,%edx
80103217:	8b 45 08             	mov    0x8(%ebp),%eax
8010321a:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
8010321d:	6a 08                	push   $0x8
8010321f:	e8 7f ff ff ff       	call   801031a3 <cmos_read>
80103224:	83 c4 04             	add    $0x4,%esp
80103227:	89 c2                	mov    %eax,%edx
80103229:	8b 45 08             	mov    0x8(%ebp),%eax
8010322c:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010322f:	6a 09                	push   $0x9
80103231:	e8 6d ff ff ff       	call   801031a3 <cmos_read>
80103236:	83 c4 04             	add    $0x4,%esp
80103239:	89 c2                	mov    %eax,%edx
8010323b:	8b 45 08             	mov    0x8(%ebp),%eax
8010323e:	89 50 14             	mov    %edx,0x14(%eax)
}
80103241:	90                   	nop
80103242:	c9                   	leave  
80103243:	c3                   	ret    

80103244 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103244:	55                   	push   %ebp
80103245:	89 e5                	mov    %esp,%ebp
80103247:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010324a:	6a 0b                	push   $0xb
8010324c:	e8 52 ff ff ff       	call   801031a3 <cmos_read>
80103251:	83 c4 04             	add    $0x4,%esp
80103254:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010325a:	83 e0 04             	and    $0x4,%eax
8010325d:	85 c0                	test   %eax,%eax
8010325f:	0f 94 c0             	sete   %al
80103262:	0f b6 c0             	movzbl %al,%eax
80103265:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103268:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010326b:	50                   	push   %eax
8010326c:	e8 62 ff ff ff       	call   801031d3 <fill_rtcdate>
80103271:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103274:	6a 0a                	push   $0xa
80103276:	e8 28 ff ff ff       	call   801031a3 <cmos_read>
8010327b:	83 c4 04             	add    $0x4,%esp
8010327e:	25 80 00 00 00       	and    $0x80,%eax
80103283:	85 c0                	test   %eax,%eax
80103285:	75 27                	jne    801032ae <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103287:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010328a:	50                   	push   %eax
8010328b:	e8 43 ff ff ff       	call   801031d3 <fill_rtcdate>
80103290:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103293:	83 ec 04             	sub    $0x4,%esp
80103296:	6a 18                	push   $0x18
80103298:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010329b:	50                   	push   %eax
8010329c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010329f:	50                   	push   %eax
801032a0:	e8 d3 21 00 00       	call   80105478 <memcmp>
801032a5:	83 c4 10             	add    $0x10,%esp
801032a8:	85 c0                	test   %eax,%eax
801032aa:	74 05                	je     801032b1 <cmostime+0x6d>
801032ac:	eb ba                	jmp    80103268 <cmostime+0x24>
        continue;
801032ae:	90                   	nop
    fill_rtcdate(&t1);
801032af:	eb b7                	jmp    80103268 <cmostime+0x24>
      break;
801032b1:	90                   	nop
  }

  // convert
  if (bcd) {
801032b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801032b6:	0f 84 b4 00 00 00    	je     80103370 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032bf:	c1 e8 04             	shr    $0x4,%eax
801032c2:	89 c2                	mov    %eax,%edx
801032c4:	89 d0                	mov    %edx,%eax
801032c6:	c1 e0 02             	shl    $0x2,%eax
801032c9:	01 d0                	add    %edx,%eax
801032cb:	01 c0                	add    %eax,%eax
801032cd:	89 c2                	mov    %eax,%edx
801032cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032d2:	83 e0 0f             	and    $0xf,%eax
801032d5:	01 d0                	add    %edx,%eax
801032d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801032da:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032dd:	c1 e8 04             	shr    $0x4,%eax
801032e0:	89 c2                	mov    %eax,%edx
801032e2:	89 d0                	mov    %edx,%eax
801032e4:	c1 e0 02             	shl    $0x2,%eax
801032e7:	01 d0                	add    %edx,%eax
801032e9:	01 c0                	add    %eax,%eax
801032eb:	89 c2                	mov    %eax,%edx
801032ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032f0:	83 e0 0f             	and    $0xf,%eax
801032f3:	01 d0                	add    %edx,%eax
801032f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801032f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032fb:	c1 e8 04             	shr    $0x4,%eax
801032fe:	89 c2                	mov    %eax,%edx
80103300:	89 d0                	mov    %edx,%eax
80103302:	c1 e0 02             	shl    $0x2,%eax
80103305:	01 d0                	add    %edx,%eax
80103307:	01 c0                	add    %eax,%eax
80103309:	89 c2                	mov    %eax,%edx
8010330b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010330e:	83 e0 0f             	and    $0xf,%eax
80103311:	01 d0                	add    %edx,%eax
80103313:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103319:	c1 e8 04             	shr    $0x4,%eax
8010331c:	89 c2                	mov    %eax,%edx
8010331e:	89 d0                	mov    %edx,%eax
80103320:	c1 e0 02             	shl    $0x2,%eax
80103323:	01 d0                	add    %edx,%eax
80103325:	01 c0                	add    %eax,%eax
80103327:	89 c2                	mov    %eax,%edx
80103329:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010332c:	83 e0 0f             	and    $0xf,%eax
8010332f:	01 d0                	add    %edx,%eax
80103331:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103334:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103337:	c1 e8 04             	shr    $0x4,%eax
8010333a:	89 c2                	mov    %eax,%edx
8010333c:	89 d0                	mov    %edx,%eax
8010333e:	c1 e0 02             	shl    $0x2,%eax
80103341:	01 d0                	add    %edx,%eax
80103343:	01 c0                	add    %eax,%eax
80103345:	89 c2                	mov    %eax,%edx
80103347:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010334a:	83 e0 0f             	and    $0xf,%eax
8010334d:	01 d0                	add    %edx,%eax
8010334f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103352:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103355:	c1 e8 04             	shr    $0x4,%eax
80103358:	89 c2                	mov    %eax,%edx
8010335a:	89 d0                	mov    %edx,%eax
8010335c:	c1 e0 02             	shl    $0x2,%eax
8010335f:	01 d0                	add    %edx,%eax
80103361:	01 c0                	add    %eax,%eax
80103363:	89 c2                	mov    %eax,%edx
80103365:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103368:	83 e0 0f             	and    $0xf,%eax
8010336b:	01 d0                	add    %edx,%eax
8010336d:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103370:	8b 45 08             	mov    0x8(%ebp),%eax
80103373:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103376:	89 10                	mov    %edx,(%eax)
80103378:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010337b:	89 50 04             	mov    %edx,0x4(%eax)
8010337e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103381:	89 50 08             	mov    %edx,0x8(%eax)
80103384:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103387:	89 50 0c             	mov    %edx,0xc(%eax)
8010338a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010338d:	89 50 10             	mov    %edx,0x10(%eax)
80103390:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103393:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103396:	8b 45 08             	mov    0x8(%ebp),%eax
80103399:	8b 40 14             	mov    0x14(%eax),%eax
8010339c:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801033a2:	8b 45 08             	mov    0x8(%ebp),%eax
801033a5:	89 50 14             	mov    %edx,0x14(%eax)
}
801033a8:	90                   	nop
801033a9:	c9                   	leave  
801033aa:	c3                   	ret    

801033ab <unixtime>:

// This is not the "real" UNIX time as it makes many
// simplifying assumptions -- no leap years, months
// that are all the same length (!)
unsigned long unixtime(void) {
801033ab:	55                   	push   %ebp
801033ac:	89 e5                	mov    %esp,%ebp
801033ae:	83 ec 28             	sub    $0x28,%esp
  struct rtcdate t;
  cmostime(&t);
801033b1:	83 ec 0c             	sub    $0xc,%esp
801033b4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801033b7:	50                   	push   %eax
801033b8:	e8 87 fe ff ff       	call   80103244 <cmostime>
801033bd:	83 c4 10             	add    $0x10,%esp
  return ((t.year - 1970) * 365 * 24 * 60 * 60) +
801033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033c3:	69 d0 80 33 e1 01    	imul   $0x1e13380,%eax,%edx
         (t.month * 30 * 24 * 60 * 60) +
801033c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033cc:	69 c0 00 8d 27 00    	imul   $0x278d00,%eax,%eax
  return ((t.year - 1970) * 365 * 24 * 60 * 60) +
801033d2:	01 c2                	add    %eax,%edx
         (t.day * 24 * 60 * 60) +
801033d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033d7:	69 c0 80 51 01 00    	imul   $0x15180,%eax,%eax
         (t.month * 30 * 24 * 60 * 60) +
801033dd:	01 c2                	add    %eax,%edx
         (t.hour * 60 * 60) +
801033df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801033e2:	69 c0 10 0e 00 00    	imul   $0xe10,%eax,%eax
         (t.day * 24 * 60 * 60) +
801033e8:	01 c2                	add    %eax,%edx
         (t.minute * 60) +
801033ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033ed:	6b c0 3c             	imul   $0x3c,%eax,%eax
         (t.hour * 60 * 60) +
801033f0:	01 c2                	add    %eax,%edx
         (t.second);
801033f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
         (t.minute * 60) +
801033f5:	01 d0                	add    %edx,%eax
801033f7:	2d 00 4f fe 76       	sub    $0x76fe4f00,%eax
}
801033fc:	c9                   	leave  
801033fd:	c3                   	ret    

801033fe <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801033fe:	55                   	push   %ebp
801033ff:	89 e5                	mov    %esp,%ebp
80103401:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103404:	83 ec 08             	sub    $0x8,%esp
80103407:	68 00 8c 10 80       	push   $0x80108c00
8010340c:	68 40 3c 11 80       	push   $0x80113c40
80103411:	e8 76 1d 00 00       	call   8010518c <initlock>
80103416:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103419:	83 ec 08             	sub    $0x8,%esp
8010341c:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010341f:	50                   	push   %eax
80103420:	ff 75 08             	pushl  0x8(%ebp)
80103423:	e8 d8 df ff ff       	call   80101400 <readsb>
80103428:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
8010342b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010342e:	a3 74 3c 11 80       	mov    %eax,0x80113c74
  log.size = sb.nlog;
80103433:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103436:	a3 78 3c 11 80       	mov    %eax,0x80113c78
  log.dev = dev;
8010343b:	8b 45 08             	mov    0x8(%ebp),%eax
8010343e:	a3 84 3c 11 80       	mov    %eax,0x80113c84
  recover_from_log();
80103443:	e8 b2 01 00 00       	call   801035fa <recover_from_log>
}
80103448:	90                   	nop
80103449:	c9                   	leave  
8010344a:	c3                   	ret    

8010344b <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010344b:	55                   	push   %ebp
8010344c:	89 e5                	mov    %esp,%ebp
8010344e:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103458:	e9 95 00 00 00       	jmp    801034f2 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010345d:	8b 15 74 3c 11 80    	mov    0x80113c74,%edx
80103463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103466:	01 d0                	add    %edx,%eax
80103468:	83 c0 01             	add    $0x1,%eax
8010346b:	89 c2                	mov    %eax,%edx
8010346d:	a1 84 3c 11 80       	mov    0x80113c84,%eax
80103472:	83 ec 08             	sub    $0x8,%esp
80103475:	52                   	push   %edx
80103476:	50                   	push   %eax
80103477:	e8 3a cd ff ff       	call   801001b6 <bread>
8010347c:	83 c4 10             	add    $0x10,%esp
8010347f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103482:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103485:	83 c0 10             	add    $0x10,%eax
80103488:	8b 04 85 4c 3c 11 80 	mov    -0x7feec3b4(,%eax,4),%eax
8010348f:	89 c2                	mov    %eax,%edx
80103491:	a1 84 3c 11 80       	mov    0x80113c84,%eax
80103496:	83 ec 08             	sub    $0x8,%esp
80103499:	52                   	push   %edx
8010349a:	50                   	push   %eax
8010349b:	e8 16 cd ff ff       	call   801001b6 <bread>
801034a0:	83 c4 10             	add    $0x10,%esp
801034a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034a9:	8d 50 18             	lea    0x18(%eax),%edx
801034ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034af:	83 c0 18             	add    $0x18,%eax
801034b2:	83 ec 04             	sub    $0x4,%esp
801034b5:	68 00 02 00 00       	push   $0x200
801034ba:	52                   	push   %edx
801034bb:	50                   	push   %eax
801034bc:	e8 0f 20 00 00       	call   801054d0 <memmove>
801034c1:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801034c4:	83 ec 0c             	sub    $0xc,%esp
801034c7:	ff 75 ec             	pushl  -0x14(%ebp)
801034ca:	e8 20 cd ff ff       	call   801001ef <bwrite>
801034cf:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801034d2:	83 ec 0c             	sub    $0xc,%esp
801034d5:	ff 75 f0             	pushl  -0x10(%ebp)
801034d8:	e8 51 cd ff ff       	call   8010022e <brelse>
801034dd:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	ff 75 ec             	pushl  -0x14(%ebp)
801034e6:	e8 43 cd ff ff       	call   8010022e <brelse>
801034eb:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801034ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034f2:	a1 88 3c 11 80       	mov    0x80113c88,%eax
801034f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034fa:	0f 8f 5d ff ff ff    	jg     8010345d <install_trans+0x12>
  }
}
80103500:	90                   	nop
80103501:	c9                   	leave  
80103502:	c3                   	ret    

80103503 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103503:	55                   	push   %ebp
80103504:	89 e5                	mov    %esp,%ebp
80103506:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103509:	a1 74 3c 11 80       	mov    0x80113c74,%eax
8010350e:	89 c2                	mov    %eax,%edx
80103510:	a1 84 3c 11 80       	mov    0x80113c84,%eax
80103515:	83 ec 08             	sub    $0x8,%esp
80103518:	52                   	push   %edx
80103519:	50                   	push   %eax
8010351a:	e8 97 cc ff ff       	call   801001b6 <bread>
8010351f:	83 c4 10             	add    $0x10,%esp
80103522:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103525:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103528:	83 c0 18             	add    $0x18,%eax
8010352b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010352e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103531:	8b 00                	mov    (%eax),%eax
80103533:	a3 88 3c 11 80       	mov    %eax,0x80113c88
  for (i = 0; i < log.lh.n; i++) {
80103538:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010353f:	eb 1b                	jmp    8010355c <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103541:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103544:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103547:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010354b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010354e:	83 c2 10             	add    $0x10,%edx
80103551:	89 04 95 4c 3c 11 80 	mov    %eax,-0x7feec3b4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103558:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010355c:	a1 88 3c 11 80       	mov    0x80113c88,%eax
80103561:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103564:	7f db                	jg     80103541 <read_head+0x3e>
  }
  brelse(buf);
80103566:	83 ec 0c             	sub    $0xc,%esp
80103569:	ff 75 f0             	pushl  -0x10(%ebp)
8010356c:	e8 bd cc ff ff       	call   8010022e <brelse>
80103571:	83 c4 10             	add    $0x10,%esp
}
80103574:	90                   	nop
80103575:	c9                   	leave  
80103576:	c3                   	ret    

80103577 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103577:	55                   	push   %ebp
80103578:	89 e5                	mov    %esp,%ebp
8010357a:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010357d:	a1 74 3c 11 80       	mov    0x80113c74,%eax
80103582:	89 c2                	mov    %eax,%edx
80103584:	a1 84 3c 11 80       	mov    0x80113c84,%eax
80103589:	83 ec 08             	sub    $0x8,%esp
8010358c:	52                   	push   %edx
8010358d:	50                   	push   %eax
8010358e:	e8 23 cc ff ff       	call   801001b6 <bread>
80103593:	83 c4 10             	add    $0x10,%esp
80103596:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103599:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010359c:	83 c0 18             	add    $0x18,%eax
8010359f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801035a2:	8b 15 88 3c 11 80    	mov    0x80113c88,%edx
801035a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ab:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801035ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035b4:	eb 1b                	jmp    801035d1 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801035b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035b9:	83 c0 10             	add    $0x10,%eax
801035bc:	8b 0c 85 4c 3c 11 80 	mov    -0x7feec3b4(,%eax,4),%ecx
801035c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035c9:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801035cd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035d1:	a1 88 3c 11 80       	mov    0x80113c88,%eax
801035d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035d9:	7f db                	jg     801035b6 <write_head+0x3f>
  }
  bwrite(buf);
801035db:	83 ec 0c             	sub    $0xc,%esp
801035de:	ff 75 f0             	pushl  -0x10(%ebp)
801035e1:	e8 09 cc ff ff       	call   801001ef <bwrite>
801035e6:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801035e9:	83 ec 0c             	sub    $0xc,%esp
801035ec:	ff 75 f0             	pushl  -0x10(%ebp)
801035ef:	e8 3a cc ff ff       	call   8010022e <brelse>
801035f4:	83 c4 10             	add    $0x10,%esp
}
801035f7:	90                   	nop
801035f8:	c9                   	leave  
801035f9:	c3                   	ret    

801035fa <recover_from_log>:

static void
recover_from_log(void)
{
801035fa:	55                   	push   %ebp
801035fb:	89 e5                	mov    %esp,%ebp
801035fd:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103600:	e8 fe fe ff ff       	call   80103503 <read_head>
  install_trans(); // if committed, copy from log to disk
80103605:	e8 41 fe ff ff       	call   8010344b <install_trans>
  log.lh.n = 0;
8010360a:	c7 05 88 3c 11 80 00 	movl   $0x0,0x80113c88
80103611:	00 00 00 
  write_head(); // clear the log
80103614:	e8 5e ff ff ff       	call   80103577 <write_head>
}
80103619:	90                   	nop
8010361a:	c9                   	leave  
8010361b:	c3                   	ret    

8010361c <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010361c:	55                   	push   %ebp
8010361d:	89 e5                	mov    %esp,%ebp
8010361f:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103622:	83 ec 0c             	sub    $0xc,%esp
80103625:	68 40 3c 11 80       	push   $0x80113c40
8010362a:	e8 7f 1b 00 00       	call   801051ae <acquire>
8010362f:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103632:	a1 80 3c 11 80       	mov    0x80113c80,%eax
80103637:	85 c0                	test   %eax,%eax
80103639:	74 17                	je     80103652 <begin_op+0x36>
      sleep(&log, &log.lock);
8010363b:	83 ec 08             	sub    $0x8,%esp
8010363e:	68 40 3c 11 80       	push   $0x80113c40
80103643:	68 40 3c 11 80       	push   $0x80113c40
80103648:	e8 68 18 00 00       	call   80104eb5 <sleep>
8010364d:	83 c4 10             	add    $0x10,%esp
80103650:	eb e0                	jmp    80103632 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103652:	8b 0d 88 3c 11 80    	mov    0x80113c88,%ecx
80103658:	a1 7c 3c 11 80       	mov    0x80113c7c,%eax
8010365d:	8d 50 01             	lea    0x1(%eax),%edx
80103660:	89 d0                	mov    %edx,%eax
80103662:	c1 e0 02             	shl    $0x2,%eax
80103665:	01 d0                	add    %edx,%eax
80103667:	01 c0                	add    %eax,%eax
80103669:	01 c8                	add    %ecx,%eax
8010366b:	83 f8 1e             	cmp    $0x1e,%eax
8010366e:	7e 17                	jle    80103687 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103670:	83 ec 08             	sub    $0x8,%esp
80103673:	68 40 3c 11 80       	push   $0x80113c40
80103678:	68 40 3c 11 80       	push   $0x80113c40
8010367d:	e8 33 18 00 00       	call   80104eb5 <sleep>
80103682:	83 c4 10             	add    $0x10,%esp
80103685:	eb ab                	jmp    80103632 <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103687:	a1 7c 3c 11 80       	mov    0x80113c7c,%eax
8010368c:	83 c0 01             	add    $0x1,%eax
8010368f:	a3 7c 3c 11 80       	mov    %eax,0x80113c7c
      release(&log.lock);
80103694:	83 ec 0c             	sub    $0xc,%esp
80103697:	68 40 3c 11 80       	push   $0x80113c40
8010369c:	e8 74 1b 00 00       	call   80105215 <release>
801036a1:	83 c4 10             	add    $0x10,%esp
      break;
801036a4:	90                   	nop
    }
  }
}
801036a5:	90                   	nop
801036a6:	c9                   	leave  
801036a7:	c3                   	ret    

801036a8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801036a8:	55                   	push   %ebp
801036a9:	89 e5                	mov    %esp,%ebp
801036ab:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801036ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801036b5:	83 ec 0c             	sub    $0xc,%esp
801036b8:	68 40 3c 11 80       	push   $0x80113c40
801036bd:	e8 ec 1a 00 00       	call   801051ae <acquire>
801036c2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801036c5:	a1 7c 3c 11 80       	mov    0x80113c7c,%eax
801036ca:	83 e8 01             	sub    $0x1,%eax
801036cd:	a3 7c 3c 11 80       	mov    %eax,0x80113c7c
  if(log.committing)
801036d2:	a1 80 3c 11 80       	mov    0x80113c80,%eax
801036d7:	85 c0                	test   %eax,%eax
801036d9:	74 0d                	je     801036e8 <end_op+0x40>
    panic("log.committing");
801036db:	83 ec 0c             	sub    $0xc,%esp
801036de:	68 04 8c 10 80       	push   $0x80108c04
801036e3:	e8 fa ce ff ff       	call   801005e2 <panic>
  if(log.outstanding == 0){
801036e8:	a1 7c 3c 11 80       	mov    0x80113c7c,%eax
801036ed:	85 c0                	test   %eax,%eax
801036ef:	75 13                	jne    80103704 <end_op+0x5c>
    do_commit = 1;
801036f1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036f8:	c7 05 80 3c 11 80 01 	movl   $0x1,0x80113c80
801036ff:	00 00 00 
80103702:	eb 10                	jmp    80103714 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103704:	83 ec 0c             	sub    $0xc,%esp
80103707:	68 40 3c 11 80       	push   $0x80113c40
8010370c:	e8 8f 18 00 00       	call   80104fa0 <wakeup>
80103711:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103714:	83 ec 0c             	sub    $0xc,%esp
80103717:	68 40 3c 11 80       	push   $0x80113c40
8010371c:	e8 f4 1a 00 00       	call   80105215 <release>
80103721:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103724:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103728:	74 3f                	je     80103769 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010372a:	e8 f5 00 00 00       	call   80103824 <commit>
    acquire(&log.lock);
8010372f:	83 ec 0c             	sub    $0xc,%esp
80103732:	68 40 3c 11 80       	push   $0x80113c40
80103737:	e8 72 1a 00 00       	call   801051ae <acquire>
8010373c:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010373f:	c7 05 80 3c 11 80 00 	movl   $0x0,0x80113c80
80103746:	00 00 00 
    wakeup(&log);
80103749:	83 ec 0c             	sub    $0xc,%esp
8010374c:	68 40 3c 11 80       	push   $0x80113c40
80103751:	e8 4a 18 00 00       	call   80104fa0 <wakeup>
80103756:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103759:	83 ec 0c             	sub    $0xc,%esp
8010375c:	68 40 3c 11 80       	push   $0x80113c40
80103761:	e8 af 1a 00 00       	call   80105215 <release>
80103766:	83 c4 10             	add    $0x10,%esp
  }
}
80103769:	90                   	nop
8010376a:	c9                   	leave  
8010376b:	c3                   	ret    

8010376c <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
8010376c:	55                   	push   %ebp
8010376d:	89 e5                	mov    %esp,%ebp
8010376f:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103772:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103779:	e9 95 00 00 00       	jmp    80103813 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010377e:	8b 15 74 3c 11 80    	mov    0x80113c74,%edx
80103784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103787:	01 d0                	add    %edx,%eax
80103789:	83 c0 01             	add    $0x1,%eax
8010378c:	89 c2                	mov    %eax,%edx
8010378e:	a1 84 3c 11 80       	mov    0x80113c84,%eax
80103793:	83 ec 08             	sub    $0x8,%esp
80103796:	52                   	push   %edx
80103797:	50                   	push   %eax
80103798:	e8 19 ca ff ff       	call   801001b6 <bread>
8010379d:	83 c4 10             	add    $0x10,%esp
801037a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801037a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037a6:	83 c0 10             	add    $0x10,%eax
801037a9:	8b 04 85 4c 3c 11 80 	mov    -0x7feec3b4(,%eax,4),%eax
801037b0:	89 c2                	mov    %eax,%edx
801037b2:	a1 84 3c 11 80       	mov    0x80113c84,%eax
801037b7:	83 ec 08             	sub    $0x8,%esp
801037ba:	52                   	push   %edx
801037bb:	50                   	push   %eax
801037bc:	e8 f5 c9 ff ff       	call   801001b6 <bread>
801037c1:	83 c4 10             	add    $0x10,%esp
801037c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801037c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037ca:	8d 50 18             	lea    0x18(%eax),%edx
801037cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037d0:	83 c0 18             	add    $0x18,%eax
801037d3:	83 ec 04             	sub    $0x4,%esp
801037d6:	68 00 02 00 00       	push   $0x200
801037db:	52                   	push   %edx
801037dc:	50                   	push   %eax
801037dd:	e8 ee 1c 00 00       	call   801054d0 <memmove>
801037e2:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801037e5:	83 ec 0c             	sub    $0xc,%esp
801037e8:	ff 75 f0             	pushl  -0x10(%ebp)
801037eb:	e8 ff c9 ff ff       	call   801001ef <bwrite>
801037f0:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801037f3:	83 ec 0c             	sub    $0xc,%esp
801037f6:	ff 75 ec             	pushl  -0x14(%ebp)
801037f9:	e8 30 ca ff ff       	call   8010022e <brelse>
801037fe:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103801:	83 ec 0c             	sub    $0xc,%esp
80103804:	ff 75 f0             	pushl  -0x10(%ebp)
80103807:	e8 22 ca ff ff       	call   8010022e <brelse>
8010380c:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010380f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103813:	a1 88 3c 11 80       	mov    0x80113c88,%eax
80103818:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010381b:	0f 8f 5d ff ff ff    	jg     8010377e <write_log+0x12>
  }
}
80103821:	90                   	nop
80103822:	c9                   	leave  
80103823:	c3                   	ret    

80103824 <commit>:

static void
commit()
{
80103824:	55                   	push   %ebp
80103825:	89 e5                	mov    %esp,%ebp
80103827:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010382a:	a1 88 3c 11 80       	mov    0x80113c88,%eax
8010382f:	85 c0                	test   %eax,%eax
80103831:	7e 1e                	jle    80103851 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103833:	e8 34 ff ff ff       	call   8010376c <write_log>
    write_head();    // Write header to disk -- the real commit
80103838:	e8 3a fd ff ff       	call   80103577 <write_head>
    install_trans(); // Now install writes to home locations
8010383d:	e8 09 fc ff ff       	call   8010344b <install_trans>
    log.lh.n = 0; 
80103842:	c7 05 88 3c 11 80 00 	movl   $0x0,0x80113c88
80103849:	00 00 00 
    write_head();    // Erase the transaction from the log
8010384c:	e8 26 fd ff ff       	call   80103577 <write_head>
  }
}
80103851:	90                   	nop
80103852:	c9                   	leave  
80103853:	c3                   	ret    

80103854 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103854:	55                   	push   %ebp
80103855:	89 e5                	mov    %esp,%ebp
80103857:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010385a:	a1 88 3c 11 80       	mov    0x80113c88,%eax
8010385f:	83 f8 1d             	cmp    $0x1d,%eax
80103862:	7f 12                	jg     80103876 <log_write+0x22>
80103864:	a1 88 3c 11 80       	mov    0x80113c88,%eax
80103869:	8b 15 78 3c 11 80    	mov    0x80113c78,%edx
8010386f:	83 ea 01             	sub    $0x1,%edx
80103872:	39 d0                	cmp    %edx,%eax
80103874:	7c 0d                	jl     80103883 <log_write+0x2f>
    panic("too big a transaction");
80103876:	83 ec 0c             	sub    $0xc,%esp
80103879:	68 13 8c 10 80       	push   $0x80108c13
8010387e:	e8 5f cd ff ff       	call   801005e2 <panic>
  if (log.outstanding < 1)
80103883:	a1 7c 3c 11 80       	mov    0x80113c7c,%eax
80103888:	85 c0                	test   %eax,%eax
8010388a:	7f 0d                	jg     80103899 <log_write+0x45>
    panic("log_write outside of trans");
8010388c:	83 ec 0c             	sub    $0xc,%esp
8010388f:	68 29 8c 10 80       	push   $0x80108c29
80103894:	e8 49 cd ff ff       	call   801005e2 <panic>

  acquire(&log.lock);
80103899:	83 ec 0c             	sub    $0xc,%esp
8010389c:	68 40 3c 11 80       	push   $0x80113c40
801038a1:	e8 08 19 00 00       	call   801051ae <acquire>
801038a6:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801038a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038b0:	eb 1d                	jmp    801038cf <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801038b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038b5:	83 c0 10             	add    $0x10,%eax
801038b8:	8b 04 85 4c 3c 11 80 	mov    -0x7feec3b4(,%eax,4),%eax
801038bf:	89 c2                	mov    %eax,%edx
801038c1:	8b 45 08             	mov    0x8(%ebp),%eax
801038c4:	8b 40 08             	mov    0x8(%eax),%eax
801038c7:	39 c2                	cmp    %eax,%edx
801038c9:	74 10                	je     801038db <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
801038cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038cf:	a1 88 3c 11 80       	mov    0x80113c88,%eax
801038d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038d7:	7f d9                	jg     801038b2 <log_write+0x5e>
801038d9:	eb 01                	jmp    801038dc <log_write+0x88>
      break;
801038db:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801038dc:	8b 45 08             	mov    0x8(%ebp),%eax
801038df:	8b 40 08             	mov    0x8(%eax),%eax
801038e2:	89 c2                	mov    %eax,%edx
801038e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038e7:	83 c0 10             	add    $0x10,%eax
801038ea:	89 14 85 4c 3c 11 80 	mov    %edx,-0x7feec3b4(,%eax,4)
  if (i == log.lh.n)
801038f1:	a1 88 3c 11 80       	mov    0x80113c88,%eax
801038f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038f9:	75 0d                	jne    80103908 <log_write+0xb4>
    log.lh.n++;
801038fb:	a1 88 3c 11 80       	mov    0x80113c88,%eax
80103900:	83 c0 01             	add    $0x1,%eax
80103903:	a3 88 3c 11 80       	mov    %eax,0x80113c88
  b->flags |= B_DIRTY; // prevent eviction
80103908:	8b 45 08             	mov    0x8(%ebp),%eax
8010390b:	8b 00                	mov    (%eax),%eax
8010390d:	83 c8 04             	or     $0x4,%eax
80103910:	89 c2                	mov    %eax,%edx
80103912:	8b 45 08             	mov    0x8(%ebp),%eax
80103915:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103917:	83 ec 0c             	sub    $0xc,%esp
8010391a:	68 40 3c 11 80       	push   $0x80113c40
8010391f:	e8 f1 18 00 00       	call   80105215 <release>
80103924:	83 c4 10             	add    $0x10,%esp
}
80103927:	90                   	nop
80103928:	c9                   	leave  
80103929:	c3                   	ret    

8010392a <v2p>:
8010392a:	55                   	push   %ebp
8010392b:	89 e5                	mov    %esp,%ebp
8010392d:	8b 45 08             	mov    0x8(%ebp),%eax
80103930:	05 00 00 00 80       	add    $0x80000000,%eax
80103935:	5d                   	pop    %ebp
80103936:	c3                   	ret    

80103937 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103937:	55                   	push   %ebp
80103938:	89 e5                	mov    %esp,%ebp
8010393a:	8b 45 08             	mov    0x8(%ebp),%eax
8010393d:	05 00 00 00 80       	add    $0x80000000,%eax
80103942:	5d                   	pop    %ebp
80103943:	c3                   	ret    

80103944 <xchg>:
    return ret;
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103944:	55                   	push   %ebp
80103945:	89 e5                	mov    %esp,%ebp
80103947:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010394a:	8b 55 08             	mov    0x8(%ebp),%edx
8010394d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103950:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103953:	f0 87 02             	lock xchg %eax,(%edx)
80103956:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103959:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010395c:	c9                   	leave  
8010395d:	c3                   	ret    

8010395e <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010395e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103962:	83 e4 f0             	and    $0xfffffff0,%esp
80103965:	ff 71 fc             	pushl  -0x4(%ecx)
80103968:	55                   	push   %ebp
80103969:	89 e5                	mov    %esp,%ebp
8010396b:	51                   	push   %ecx
8010396c:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010396f:	83 ec 08             	sub    $0x8,%esp
80103972:	68 00 00 40 80       	push   $0x80400000
80103977:	68 3c 6c 11 80       	push   $0x80116c3c
8010397c:	e8 2a f2 ff ff       	call   80102bab <kinit1>
80103981:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103984:	e8 88 48 00 00       	call   80108211 <kvmalloc>
  mpinit();        // collect info about this machine
80103989:	e8 43 04 00 00       	call   80103dd1 <mpinit>
  lapicinit();
8010398e:	e8 97 f5 ff ff       	call   80102f2a <lapicinit>
  seginit();       // set up segments
80103993:	e8 22 42 00 00       	call   80107bba <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103998:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010399e:	0f b6 00             	movzbl (%eax),%eax
801039a1:	0f b6 c0             	movzbl %al,%eax
801039a4:	83 ec 08             	sub    $0x8,%esp
801039a7:	50                   	push   %eax
801039a8:	68 44 8c 10 80       	push   $0x80108c44
801039ad:	e8 68 ca ff ff       	call   8010041a <cprintf>
801039b2:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
801039b5:	e8 6d 06 00 00       	call   80104027 <picinit>
  ioapicinit();    // another interrupt controller
801039ba:	e8 e1 f0 ff ff       	call   80102aa0 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801039bf:	e8 d1 d1 ff ff       	call   80100b95 <consoleinit>
  uartinit();      // serial port
801039c4:	e8 0b 33 00 00       	call   80106cd4 <uartinit>
  pinit();         // process table
801039c9:	e8 5d 0b 00 00       	call   8010452b <pinit>
  tvinit();        // trap vectors
801039ce:	e8 cb 2e 00 00       	call   8010689e <tvinit>
  binit();         // buffer cache
801039d3:	e8 5c c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801039d8:	e8 14 d6 ff ff       	call   80100ff1 <fileinit>
  ideinit();       // disk
801039dd:	e8 c6 ec ff ff       	call   801026a8 <ideinit>
  if(!ismp)
801039e2:	a1 24 3d 11 80       	mov    0x80113d24,%eax
801039e7:	85 c0                	test   %eax,%eax
801039e9:	75 05                	jne    801039f0 <main+0x92>
    timerinit();   // uniprocessor timer
801039eb:	e8 0b 2e 00 00       	call   801067fb <timerinit>
  startothers();   // start other processors
801039f0:	e8 7f 00 00 00       	call   80103a74 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039f5:	83 ec 08             	sub    $0x8,%esp
801039f8:	68 00 00 00 8e       	push   $0x8e000000
801039fd:	68 00 00 40 80       	push   $0x80400000
80103a02:	e8 dd f1 ff ff       	call   80102be4 <kinit2>
80103a07:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103a0a:	e8 5b 0c 00 00       	call   8010466a <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103a0f:	e8 1a 00 00 00       	call   80103a2e <mpmain>

80103a14 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103a1a:	e8 0a 48 00 00       	call   80108229 <switchkvm>
  seginit();
80103a1f:	e8 96 41 00 00       	call   80107bba <seginit>
  lapicinit();
80103a24:	e8 01 f5 ff ff       	call   80102f2a <lapicinit>
  mpmain();
80103a29:	e8 00 00 00 00       	call   80103a2e <mpmain>

80103a2e <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103a2e:	55                   	push   %ebp
80103a2f:	89 e5                	mov    %esp,%ebp
80103a31:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103a34:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a3a:	0f b6 00             	movzbl (%eax),%eax
80103a3d:	0f b6 c0             	movzbl %al,%eax
80103a40:	83 ec 08             	sub    $0x8,%esp
80103a43:	50                   	push   %eax
80103a44:	68 5b 8c 10 80       	push   $0x80108c5b
80103a49:	e8 cc c9 ff ff       	call   8010041a <cprintf>
80103a4e:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a51:	e8 be 2f 00 00       	call   80106a14 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a56:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a5c:	05 a8 00 00 00       	add    $0xa8,%eax
80103a61:	83 ec 08             	sub    $0x8,%esp
80103a64:	6a 01                	push   $0x1
80103a66:	50                   	push   %eax
80103a67:	e8 d8 fe ff ff       	call   80103944 <xchg>
80103a6c:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a6f:	e8 ab 11 00 00       	call   80104c1f <scheduler>

80103a74 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	53                   	push   %ebx
80103a78:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103a7b:	68 00 70 00 00       	push   $0x7000
80103a80:	e8 b2 fe ff ff       	call   80103937 <p2v>
80103a85:	83 c4 04             	add    $0x4,%esp
80103a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a8b:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a90:	83 ec 04             	sub    $0x4,%esp
80103a93:	50                   	push   %eax
80103a94:	68 2c c5 10 80       	push   $0x8010c52c
80103a99:	ff 75 f0             	pushl  -0x10(%ebp)
80103a9c:	e8 2f 1a 00 00       	call   801054d0 <memmove>
80103aa1:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103aa4:	c7 45 f4 40 3d 11 80 	movl   $0x80113d40,-0xc(%ebp)
80103aab:	e9 90 00 00 00       	jmp    80103b40 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103ab0:	e8 93 f5 ff ff       	call   80103048 <cpunum>
80103ab5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103abb:	05 40 3d 11 80       	add    $0x80113d40,%eax
80103ac0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103ac3:	74 73                	je     80103b38 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103ac5:	e8 18 f2 ff ff       	call   80102ce2 <kalloc>
80103aca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ad0:	83 e8 04             	sub    $0x4,%eax
80103ad3:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103ad6:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103adc:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ae1:	83 e8 08             	sub    $0x8,%eax
80103ae4:	c7 00 14 3a 10 80    	movl   $0x80103a14,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aed:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103af0:	83 ec 0c             	sub    $0xc,%esp
80103af3:	68 00 b0 10 80       	push   $0x8010b000
80103af8:	e8 2d fe ff ff       	call   8010392a <v2p>
80103afd:	83 c4 10             	add    $0x10,%esp
80103b00:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103b02:	83 ec 0c             	sub    $0xc,%esp
80103b05:	ff 75 f0             	pushl  -0x10(%ebp)
80103b08:	e8 1d fe ff ff       	call   8010392a <v2p>
80103b0d:	83 c4 10             	add    $0x10,%esp
80103b10:	89 c2                	mov    %eax,%edx
80103b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b15:	0f b6 00             	movzbl (%eax),%eax
80103b18:	0f b6 c0             	movzbl %al,%eax
80103b1b:	83 ec 08             	sub    $0x8,%esp
80103b1e:	52                   	push   %edx
80103b1f:	50                   	push   %eax
80103b20:	e8 9d f5 ff ff       	call   801030c2 <lapicstartap>
80103b25:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103b28:	90                   	nop
80103b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b2c:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103b32:	85 c0                	test   %eax,%eax
80103b34:	74 f3                	je     80103b29 <startothers+0xb5>
80103b36:	eb 01                	jmp    80103b39 <startothers+0xc5>
      continue;
80103b38:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103b39:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103b40:	a1 20 43 11 80       	mov    0x80114320,%eax
80103b45:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b4b:	05 40 3d 11 80       	add    $0x80113d40,%eax
80103b50:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b53:	0f 87 57 ff ff ff    	ja     80103ab0 <startothers+0x3c>
      ;
  }
}
80103b59:	90                   	nop
80103b5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b5d:	c9                   	leave  
80103b5e:	c3                   	ret    

80103b5f <p2v>:
80103b5f:	55                   	push   %ebp
80103b60:	89 e5                	mov    %esp,%ebp
80103b62:	8b 45 08             	mov    0x8(%ebp),%eax
80103b65:	05 00 00 00 80       	add    $0x80000000,%eax
80103b6a:	5d                   	pop    %ebp
80103b6b:	c3                   	ret    

80103b6c <inb>:
{
80103b6c:	55                   	push   %ebp
80103b6d:	89 e5                	mov    %esp,%ebp
80103b6f:	83 ec 14             	sub    $0x14,%esp
80103b72:	8b 45 08             	mov    0x8(%ebp),%eax
80103b75:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b79:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103b7d:	89 c2                	mov    %eax,%edx
80103b7f:	ec                   	in     (%dx),%al
80103b80:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103b83:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103b87:	c9                   	leave  
80103b88:	c3                   	ret    

80103b89 <outb>:
{
80103b89:	55                   	push   %ebp
80103b8a:	89 e5                	mov    %esp,%ebp
80103b8c:	83 ec 08             	sub    $0x8,%esp
80103b8f:	8b 55 08             	mov    0x8(%ebp),%edx
80103b92:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b95:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b99:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b9c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103ba0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103ba4:	ee                   	out    %al,(%dx)
}
80103ba5:	90                   	nop
80103ba6:	c9                   	leave  
80103ba7:	c3                   	ret    

80103ba8 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103ba8:	55                   	push   %ebp
80103ba9:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103bab:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103bb0:	89 c2                	mov    %eax,%edx
80103bb2:	b8 40 3d 11 80       	mov    $0x80113d40,%eax
80103bb7:	29 c2                	sub    %eax,%edx
80103bb9:	89 d0                	mov    %edx,%eax
80103bbb:	c1 f8 02             	sar    $0x2,%eax
80103bbe:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103bc4:	5d                   	pop    %ebp
80103bc5:	c3                   	ret    

80103bc6 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103bc6:	55                   	push   %ebp
80103bc7:	89 e5                	mov    %esp,%ebp
80103bc9:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103bcc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103bd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103bda:	eb 15                	jmp    80103bf1 <sum+0x2b>
    sum += addr[i];
80103bdc:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103bdf:	8b 45 08             	mov    0x8(%ebp),%eax
80103be2:	01 d0                	add    %edx,%eax
80103be4:	0f b6 00             	movzbl (%eax),%eax
80103be7:	0f b6 c0             	movzbl %al,%eax
80103bea:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103bed:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bf4:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103bf7:	7c e3                	jl     80103bdc <sum+0x16>
  return sum;
80103bf9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103bfc:	c9                   	leave  
80103bfd:	c3                   	ret    

80103bfe <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103bfe:	55                   	push   %ebp
80103bff:	89 e5                	mov    %esp,%ebp
80103c01:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103c04:	ff 75 08             	pushl  0x8(%ebp)
80103c07:	e8 53 ff ff ff       	call   80103b5f <p2v>
80103c0c:	83 c4 04             	add    $0x4,%esp
80103c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103c12:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c18:	01 d0                	add    %edx,%eax
80103c1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c23:	eb 36                	jmp    80103c5b <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c25:	83 ec 04             	sub    $0x4,%esp
80103c28:	6a 04                	push   $0x4
80103c2a:	68 6c 8c 10 80       	push   $0x80108c6c
80103c2f:	ff 75 f4             	pushl  -0xc(%ebp)
80103c32:	e8 41 18 00 00       	call   80105478 <memcmp>
80103c37:	83 c4 10             	add    $0x10,%esp
80103c3a:	85 c0                	test   %eax,%eax
80103c3c:	75 19                	jne    80103c57 <mpsearch1+0x59>
80103c3e:	83 ec 08             	sub    $0x8,%esp
80103c41:	6a 10                	push   $0x10
80103c43:	ff 75 f4             	pushl  -0xc(%ebp)
80103c46:	e8 7b ff ff ff       	call   80103bc6 <sum>
80103c4b:	83 c4 10             	add    $0x10,%esp
80103c4e:	84 c0                	test   %al,%al
80103c50:	75 05                	jne    80103c57 <mpsearch1+0x59>
      return (struct mp*)p;
80103c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c55:	eb 11                	jmp    80103c68 <mpsearch1+0x6a>
  for(p = addr; p < e; p += sizeof(struct mp))
80103c57:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103c61:	72 c2                	jb     80103c25 <mpsearch1+0x27>
  return 0;
80103c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103c68:	c9                   	leave  
80103c69:	c3                   	ret    

80103c6a <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103c6a:	55                   	push   %ebp
80103c6b:	89 e5                	mov    %esp,%ebp
80103c6d:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103c70:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c7a:	83 c0 0f             	add    $0xf,%eax
80103c7d:	0f b6 00             	movzbl (%eax),%eax
80103c80:	0f b6 c0             	movzbl %al,%eax
80103c83:	c1 e0 08             	shl    $0x8,%eax
80103c86:	89 c2                	mov    %eax,%edx
80103c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c8b:	83 c0 0e             	add    $0xe,%eax
80103c8e:	0f b6 00             	movzbl (%eax),%eax
80103c91:	0f b6 c0             	movzbl %al,%eax
80103c94:	09 d0                	or     %edx,%eax
80103c96:	c1 e0 04             	shl    $0x4,%eax
80103c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103ca0:	74 21                	je     80103cc3 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103ca2:	83 ec 08             	sub    $0x8,%esp
80103ca5:	68 00 04 00 00       	push   $0x400
80103caa:	ff 75 f0             	pushl  -0x10(%ebp)
80103cad:	e8 4c ff ff ff       	call   80103bfe <mpsearch1>
80103cb2:	83 c4 10             	add    $0x10,%esp
80103cb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103cbc:	74 51                	je     80103d0f <mpsearch+0xa5>
      return mp;
80103cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103cc1:	eb 61                	jmp    80103d24 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc6:	83 c0 14             	add    $0x14,%eax
80103cc9:	0f b6 00             	movzbl (%eax),%eax
80103ccc:	0f b6 c0             	movzbl %al,%eax
80103ccf:	c1 e0 08             	shl    $0x8,%eax
80103cd2:	89 c2                	mov    %eax,%edx
80103cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd7:	83 c0 13             	add    $0x13,%eax
80103cda:	0f b6 00             	movzbl (%eax),%eax
80103cdd:	0f b6 c0             	movzbl %al,%eax
80103ce0:	09 d0                	or     %edx,%eax
80103ce2:	c1 e0 0a             	shl    $0xa,%eax
80103ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ceb:	2d 00 04 00 00       	sub    $0x400,%eax
80103cf0:	83 ec 08             	sub    $0x8,%esp
80103cf3:	68 00 04 00 00       	push   $0x400
80103cf8:	50                   	push   %eax
80103cf9:	e8 00 ff ff ff       	call   80103bfe <mpsearch1>
80103cfe:	83 c4 10             	add    $0x10,%esp
80103d01:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d08:	74 05                	je     80103d0f <mpsearch+0xa5>
      return mp;
80103d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d0d:	eb 15                	jmp    80103d24 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103d0f:	83 ec 08             	sub    $0x8,%esp
80103d12:	68 00 00 01 00       	push   $0x10000
80103d17:	68 00 00 0f 00       	push   $0xf0000
80103d1c:	e8 dd fe ff ff       	call   80103bfe <mpsearch1>
80103d21:	83 c4 10             	add    $0x10,%esp
}
80103d24:	c9                   	leave  
80103d25:	c3                   	ret    

80103d26 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103d26:	55                   	push   %ebp
80103d27:	89 e5                	mov    %esp,%ebp
80103d29:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d2c:	e8 39 ff ff ff       	call   80103c6a <mpsearch>
80103d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d38:	74 0a                	je     80103d44 <mpconfig+0x1e>
80103d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d3d:	8b 40 04             	mov    0x4(%eax),%eax
80103d40:	85 c0                	test   %eax,%eax
80103d42:	75 0a                	jne    80103d4e <mpconfig+0x28>
    return 0;
80103d44:	b8 00 00 00 00       	mov    $0x0,%eax
80103d49:	e9 81 00 00 00       	jmp    80103dcf <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d51:	8b 40 04             	mov    0x4(%eax),%eax
80103d54:	83 ec 0c             	sub    $0xc,%esp
80103d57:	50                   	push   %eax
80103d58:	e8 02 fe ff ff       	call   80103b5f <p2v>
80103d5d:	83 c4 10             	add    $0x10,%esp
80103d60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d63:	83 ec 04             	sub    $0x4,%esp
80103d66:	6a 04                	push   $0x4
80103d68:	68 71 8c 10 80       	push   $0x80108c71
80103d6d:	ff 75 f0             	pushl  -0x10(%ebp)
80103d70:	e8 03 17 00 00       	call   80105478 <memcmp>
80103d75:	83 c4 10             	add    $0x10,%esp
80103d78:	85 c0                	test   %eax,%eax
80103d7a:	74 07                	je     80103d83 <mpconfig+0x5d>
    return 0;
80103d7c:	b8 00 00 00 00       	mov    $0x0,%eax
80103d81:	eb 4c                	jmp    80103dcf <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d86:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d8a:	3c 01                	cmp    $0x1,%al
80103d8c:	74 12                	je     80103da0 <mpconfig+0x7a>
80103d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d91:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d95:	3c 04                	cmp    $0x4,%al
80103d97:	74 07                	je     80103da0 <mpconfig+0x7a>
    return 0;
80103d99:	b8 00 00 00 00       	mov    $0x0,%eax
80103d9e:	eb 2f                	jmp    80103dcf <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103da3:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103da7:	0f b7 c0             	movzwl %ax,%eax
80103daa:	83 ec 08             	sub    $0x8,%esp
80103dad:	50                   	push   %eax
80103dae:	ff 75 f0             	pushl  -0x10(%ebp)
80103db1:	e8 10 fe ff ff       	call   80103bc6 <sum>
80103db6:	83 c4 10             	add    $0x10,%esp
80103db9:	84 c0                	test   %al,%al
80103dbb:	74 07                	je     80103dc4 <mpconfig+0x9e>
    return 0;
80103dbd:	b8 00 00 00 00       	mov    $0x0,%eax
80103dc2:	eb 0b                	jmp    80103dcf <mpconfig+0xa9>
  *pmp = mp;
80103dc4:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103dca:	89 10                	mov    %edx,(%eax)
  return conf;
80103dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103dcf:	c9                   	leave  
80103dd0:	c3                   	ret    

80103dd1 <mpinit>:

void
mpinit(void)
{
80103dd1:	55                   	push   %ebp
80103dd2:	89 e5                	mov    %esp,%ebp
80103dd4:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103dd7:	c7 05 64 c6 10 80 40 	movl   $0x80113d40,0x8010c664
80103dde:	3d 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103de1:	83 ec 0c             	sub    $0xc,%esp
80103de4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103de7:	50                   	push   %eax
80103de8:	e8 39 ff ff ff       	call   80103d26 <mpconfig>
80103ded:	83 c4 10             	add    $0x10,%esp
80103df0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103df3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103df7:	0f 84 96 01 00 00    	je     80103f93 <mpinit+0x1c2>
    return;
  ismp = 1;
80103dfd:	c7 05 24 3d 11 80 01 	movl   $0x1,0x80113d24
80103e04:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e0a:	8b 40 24             	mov    0x24(%eax),%eax
80103e0d:	a3 3c 3c 11 80       	mov    %eax,0x80113c3c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e15:	83 c0 2c             	add    $0x2c,%eax
80103e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e1e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e22:	0f b7 d0             	movzwl %ax,%edx
80103e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e28:	01 d0                	add    %edx,%eax
80103e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e2d:	e9 f2 00 00 00       	jmp    80103f24 <mpinit+0x153>
    switch(*p){
80103e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e35:	0f b6 00             	movzbl (%eax),%eax
80103e38:	0f b6 c0             	movzbl %al,%eax
80103e3b:	83 f8 04             	cmp    $0x4,%eax
80103e3e:	0f 87 bc 00 00 00    	ja     80103f00 <mpinit+0x12f>
80103e44:	8b 04 85 b4 8c 10 80 	mov    -0x7fef734c(,%eax,4),%eax
80103e4b:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e50:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e53:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e56:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e5a:	0f b6 d0             	movzbl %al,%edx
80103e5d:	a1 20 43 11 80       	mov    0x80114320,%eax
80103e62:	39 c2                	cmp    %eax,%edx
80103e64:	74 2b                	je     80103e91 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e66:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e69:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e6d:	0f b6 d0             	movzbl %al,%edx
80103e70:	a1 20 43 11 80       	mov    0x80114320,%eax
80103e75:	83 ec 04             	sub    $0x4,%esp
80103e78:	52                   	push   %edx
80103e79:	50                   	push   %eax
80103e7a:	68 76 8c 10 80       	push   $0x80108c76
80103e7f:	e8 96 c5 ff ff       	call   8010041a <cprintf>
80103e84:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e87:	c7 05 24 3d 11 80 00 	movl   $0x0,0x80113d24
80103e8e:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e91:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e94:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103e98:	0f b6 c0             	movzbl %al,%eax
80103e9b:	83 e0 02             	and    $0x2,%eax
80103e9e:	85 c0                	test   %eax,%eax
80103ea0:	74 15                	je     80103eb7 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103ea2:	a1 20 43 11 80       	mov    0x80114320,%eax
80103ea7:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103ead:	05 40 3d 11 80       	add    $0x80113d40,%eax
80103eb2:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103eb7:	a1 20 43 11 80       	mov    0x80114320,%eax
80103ebc:	8b 15 20 43 11 80    	mov    0x80114320,%edx
80103ec2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103ec8:	05 40 3d 11 80       	add    $0x80113d40,%eax
80103ecd:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103ecf:	a1 20 43 11 80       	mov    0x80114320,%eax
80103ed4:	83 c0 01             	add    $0x1,%eax
80103ed7:	a3 20 43 11 80       	mov    %eax,0x80114320
      p += sizeof(struct mpproc);
80103edc:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103ee0:	eb 42                	jmp    80103f24 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ee5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103eeb:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103eef:	a2 20 3d 11 80       	mov    %al,0x80113d20
      p += sizeof(struct mpioapic);
80103ef4:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ef8:	eb 2a                	jmp    80103f24 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103efa:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103efe:	eb 24                	jmp    80103f24 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f03:	0f b6 00             	movzbl (%eax),%eax
80103f06:	0f b6 c0             	movzbl %al,%eax
80103f09:	83 ec 08             	sub    $0x8,%esp
80103f0c:	50                   	push   %eax
80103f0d:	68 94 8c 10 80       	push   $0x80108c94
80103f12:	e8 03 c5 ff ff       	call   8010041a <cprintf>
80103f17:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103f1a:	c7 05 24 3d 11 80 00 	movl   $0x0,0x80113d24
80103f21:	00 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f27:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103f2a:	0f 82 02 ff ff ff    	jb     80103e32 <mpinit+0x61>
    }
  }
  if(!ismp){
80103f30:	a1 24 3d 11 80       	mov    0x80113d24,%eax
80103f35:	85 c0                	test   %eax,%eax
80103f37:	75 1d                	jne    80103f56 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f39:	c7 05 20 43 11 80 01 	movl   $0x1,0x80114320
80103f40:	00 00 00 
    lapic = 0;
80103f43:	c7 05 3c 3c 11 80 00 	movl   $0x0,0x80113c3c
80103f4a:	00 00 00 
    ioapicid = 0;
80103f4d:	c6 05 20 3d 11 80 00 	movb   $0x0,0x80113d20
    return;
80103f54:	eb 3e                	jmp    80103f94 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103f56:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f59:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f5d:	84 c0                	test   %al,%al
80103f5f:	74 33                	je     80103f94 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f61:	83 ec 08             	sub    $0x8,%esp
80103f64:	6a 70                	push   $0x70
80103f66:	6a 22                	push   $0x22
80103f68:	e8 1c fc ff ff       	call   80103b89 <outb>
80103f6d:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f70:	83 ec 0c             	sub    $0xc,%esp
80103f73:	6a 23                	push   $0x23
80103f75:	e8 f2 fb ff ff       	call   80103b6c <inb>
80103f7a:	83 c4 10             	add    $0x10,%esp
80103f7d:	83 c8 01             	or     $0x1,%eax
80103f80:	0f b6 c0             	movzbl %al,%eax
80103f83:	83 ec 08             	sub    $0x8,%esp
80103f86:	50                   	push   %eax
80103f87:	6a 23                	push   $0x23
80103f89:	e8 fb fb ff ff       	call   80103b89 <outb>
80103f8e:	83 c4 10             	add    $0x10,%esp
80103f91:	eb 01                	jmp    80103f94 <mpinit+0x1c3>
    return;
80103f93:	90                   	nop
  }
}
80103f94:	c9                   	leave  
80103f95:	c3                   	ret    

80103f96 <outb>:
{
80103f96:	55                   	push   %ebp
80103f97:	89 e5                	mov    %esp,%ebp
80103f99:	83 ec 08             	sub    $0x8,%esp
80103f9c:	8b 55 08             	mov    0x8(%ebp),%edx
80103f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fa2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103fa6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103fa9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103fad:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103fb1:	ee                   	out    %al,(%dx)
}
80103fb2:	90                   	nop
80103fb3:	c9                   	leave  
80103fb4:	c3                   	ret    

80103fb5 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103fb5:	55                   	push   %ebp
80103fb6:	89 e5                	mov    %esp,%ebp
80103fb8:	83 ec 04             	sub    $0x4,%esp
80103fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fbe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103fc2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fc6:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103fcc:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fd0:	0f b6 c0             	movzbl %al,%eax
80103fd3:	50                   	push   %eax
80103fd4:	6a 21                	push   $0x21
80103fd6:	e8 bb ff ff ff       	call   80103f96 <outb>
80103fdb:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103fde:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fe2:	66 c1 e8 08          	shr    $0x8,%ax
80103fe6:	0f b6 c0             	movzbl %al,%eax
80103fe9:	50                   	push   %eax
80103fea:	68 a1 00 00 00       	push   $0xa1
80103fef:	e8 a2 ff ff ff       	call   80103f96 <outb>
80103ff4:	83 c4 08             	add    $0x8,%esp
}
80103ff7:	90                   	nop
80103ff8:	c9                   	leave  
80103ff9:	c3                   	ret    

80103ffa <picenable>:

void
picenable(int irq)
{
80103ffa:	55                   	push   %ebp
80103ffb:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80104000:	ba 01 00 00 00       	mov    $0x1,%edx
80104005:	89 c1                	mov    %eax,%ecx
80104007:	d3 e2                	shl    %cl,%edx
80104009:	89 d0                	mov    %edx,%eax
8010400b:	f7 d0                	not    %eax
8010400d:	89 c2                	mov    %eax,%edx
8010400f:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104016:	21 d0                	and    %edx,%eax
80104018:	0f b7 c0             	movzwl %ax,%eax
8010401b:	50                   	push   %eax
8010401c:	e8 94 ff ff ff       	call   80103fb5 <picsetmask>
80104021:	83 c4 04             	add    $0x4,%esp
}
80104024:	90                   	nop
80104025:	c9                   	leave  
80104026:	c3                   	ret    

80104027 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104027:	55                   	push   %ebp
80104028:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
8010402a:	68 ff 00 00 00       	push   $0xff
8010402f:	6a 21                	push   $0x21
80104031:	e8 60 ff ff ff       	call   80103f96 <outb>
80104036:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104039:	68 ff 00 00 00       	push   $0xff
8010403e:	68 a1 00 00 00       	push   $0xa1
80104043:	e8 4e ff ff ff       	call   80103f96 <outb>
80104048:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
8010404b:	6a 11                	push   $0x11
8010404d:	6a 20                	push   $0x20
8010404f:	e8 42 ff ff ff       	call   80103f96 <outb>
80104054:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104057:	6a 20                	push   $0x20
80104059:	6a 21                	push   $0x21
8010405b:	e8 36 ff ff ff       	call   80103f96 <outb>
80104060:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80104063:	6a 04                	push   $0x4
80104065:	6a 21                	push   $0x21
80104067:	e8 2a ff ff ff       	call   80103f96 <outb>
8010406c:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
8010406f:	6a 03                	push   $0x3
80104071:	6a 21                	push   $0x21
80104073:	e8 1e ff ff ff       	call   80103f96 <outb>
80104078:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
8010407b:	6a 11                	push   $0x11
8010407d:	68 a0 00 00 00       	push   $0xa0
80104082:	e8 0f ff ff ff       	call   80103f96 <outb>
80104087:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
8010408a:	6a 28                	push   $0x28
8010408c:	68 a1 00 00 00       	push   $0xa1
80104091:	e8 00 ff ff ff       	call   80103f96 <outb>
80104096:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104099:	6a 02                	push   $0x2
8010409b:	68 a1 00 00 00       	push   $0xa1
801040a0:	e8 f1 fe ff ff       	call   80103f96 <outb>
801040a5:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
801040a8:	6a 03                	push   $0x3
801040aa:	68 a1 00 00 00       	push   $0xa1
801040af:	e8 e2 fe ff ff       	call   80103f96 <outb>
801040b4:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
801040b7:	6a 68                	push   $0x68
801040b9:	6a 20                	push   $0x20
801040bb:	e8 d6 fe ff ff       	call   80103f96 <outb>
801040c0:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
801040c3:	6a 0a                	push   $0xa
801040c5:	6a 20                	push   $0x20
801040c7:	e8 ca fe ff ff       	call   80103f96 <outb>
801040cc:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
801040cf:	6a 68                	push   $0x68
801040d1:	68 a0 00 00 00       	push   $0xa0
801040d6:	e8 bb fe ff ff       	call   80103f96 <outb>
801040db:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801040de:	6a 0a                	push   $0xa
801040e0:	68 a0 00 00 00       	push   $0xa0
801040e5:	e8 ac fe ff ff       	call   80103f96 <outb>
801040ea:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801040ed:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801040f4:	66 83 f8 ff          	cmp    $0xffff,%ax
801040f8:	74 13                	je     8010410d <picinit+0xe6>
    picsetmask(irqmask);
801040fa:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104101:	0f b7 c0             	movzwl %ax,%eax
80104104:	50                   	push   %eax
80104105:	e8 ab fe ff ff       	call   80103fb5 <picsetmask>
8010410a:	83 c4 04             	add    $0x4,%esp
}
8010410d:	90                   	nop
8010410e:	c9                   	leave  
8010410f:	c3                   	ret    

80104110 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80104116:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010411d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104126:	8b 45 0c             	mov    0xc(%ebp),%eax
80104129:	8b 10                	mov    (%eax),%edx
8010412b:	8b 45 08             	mov    0x8(%ebp),%eax
8010412e:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104130:	e8 da ce ff ff       	call   8010100f <filealloc>
80104135:	89 c2                	mov    %eax,%edx
80104137:	8b 45 08             	mov    0x8(%ebp),%eax
8010413a:	89 10                	mov    %edx,(%eax)
8010413c:	8b 45 08             	mov    0x8(%ebp),%eax
8010413f:	8b 00                	mov    (%eax),%eax
80104141:	85 c0                	test   %eax,%eax
80104143:	0f 84 cb 00 00 00    	je     80104214 <pipealloc+0x104>
80104149:	e8 c1 ce ff ff       	call   8010100f <filealloc>
8010414e:	89 c2                	mov    %eax,%edx
80104150:	8b 45 0c             	mov    0xc(%ebp),%eax
80104153:	89 10                	mov    %edx,(%eax)
80104155:	8b 45 0c             	mov    0xc(%ebp),%eax
80104158:	8b 00                	mov    (%eax),%eax
8010415a:	85 c0                	test   %eax,%eax
8010415c:	0f 84 b2 00 00 00    	je     80104214 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104162:	e8 7b eb ff ff       	call   80102ce2 <kalloc>
80104167:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010416a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010416e:	0f 84 9f 00 00 00    	je     80104213 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80104174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104177:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010417e:	00 00 00 
  p->writeopen = 1;
80104181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104184:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010418b:	00 00 00 
  p->nwrite = 0;
8010418e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104191:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104198:	00 00 00 
  p->nread = 0;
8010419b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419e:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801041a5:	00 00 00 
  initlock(&p->lock, "pipe");
801041a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ab:	83 ec 08             	sub    $0x8,%esp
801041ae:	68 c8 8c 10 80       	push   $0x80108cc8
801041b3:	50                   	push   %eax
801041b4:	e8 d3 0f 00 00       	call   8010518c <initlock>
801041b9:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801041bc:	8b 45 08             	mov    0x8(%ebp),%eax
801041bf:	8b 00                	mov    (%eax),%eax
801041c1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801041c7:	8b 45 08             	mov    0x8(%ebp),%eax
801041ca:	8b 00                	mov    (%eax),%eax
801041cc:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801041d0:	8b 45 08             	mov    0x8(%ebp),%eax
801041d3:	8b 00                	mov    (%eax),%eax
801041d5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801041d9:	8b 45 08             	mov    0x8(%ebp),%eax
801041dc:	8b 00                	mov    (%eax),%eax
801041de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041e1:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801041e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801041e7:	8b 00                	mov    (%eax),%eax
801041e9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801041ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801041f2:	8b 00                	mov    (%eax),%eax
801041f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801041f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801041fb:	8b 00                	mov    (%eax),%eax
801041fd:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104201:	8b 45 0c             	mov    0xc(%ebp),%eax
80104204:	8b 00                	mov    (%eax),%eax
80104206:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104209:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010420c:	b8 00 00 00 00       	mov    $0x0,%eax
80104211:	eb 4e                	jmp    80104261 <pipealloc+0x151>
    goto bad;
80104213:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80104214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104218:	74 0e                	je     80104228 <pipealloc+0x118>
    kfree((char*)p);
8010421a:	83 ec 0c             	sub    $0xc,%esp
8010421d:	ff 75 f4             	pushl  -0xc(%ebp)
80104220:	e8 20 ea ff ff       	call   80102c45 <kfree>
80104225:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104228:	8b 45 08             	mov    0x8(%ebp),%eax
8010422b:	8b 00                	mov    (%eax),%eax
8010422d:	85 c0                	test   %eax,%eax
8010422f:	74 11                	je     80104242 <pipealloc+0x132>
    fileclose(*f0);
80104231:	8b 45 08             	mov    0x8(%ebp),%eax
80104234:	8b 00                	mov    (%eax),%eax
80104236:	83 ec 0c             	sub    $0xc,%esp
80104239:	50                   	push   %eax
8010423a:	e8 8e ce ff ff       	call   801010cd <fileclose>
8010423f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104242:	8b 45 0c             	mov    0xc(%ebp),%eax
80104245:	8b 00                	mov    (%eax),%eax
80104247:	85 c0                	test   %eax,%eax
80104249:	74 11                	je     8010425c <pipealloc+0x14c>
    fileclose(*f1);
8010424b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010424e:	8b 00                	mov    (%eax),%eax
80104250:	83 ec 0c             	sub    $0xc,%esp
80104253:	50                   	push   %eax
80104254:	e8 74 ce ff ff       	call   801010cd <fileclose>
80104259:	83 c4 10             	add    $0x10,%esp
  return -1;
8010425c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104261:	c9                   	leave  
80104262:	c3                   	ret    

80104263 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104263:	55                   	push   %ebp
80104264:	89 e5                	mov    %esp,%ebp
80104266:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104269:	8b 45 08             	mov    0x8(%ebp),%eax
8010426c:	83 ec 0c             	sub    $0xc,%esp
8010426f:	50                   	push   %eax
80104270:	e8 39 0f 00 00       	call   801051ae <acquire>
80104275:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104278:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010427c:	74 23                	je     801042a1 <pipeclose+0x3e>
    p->writeopen = 0;
8010427e:	8b 45 08             	mov    0x8(%ebp),%eax
80104281:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104288:	00 00 00 
    wakeup(&p->nread);
8010428b:	8b 45 08             	mov    0x8(%ebp),%eax
8010428e:	05 34 02 00 00       	add    $0x234,%eax
80104293:	83 ec 0c             	sub    $0xc,%esp
80104296:	50                   	push   %eax
80104297:	e8 04 0d 00 00       	call   80104fa0 <wakeup>
8010429c:	83 c4 10             	add    $0x10,%esp
8010429f:	eb 21                	jmp    801042c2 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801042a1:	8b 45 08             	mov    0x8(%ebp),%eax
801042a4:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801042ab:	00 00 00 
    wakeup(&p->nwrite);
801042ae:	8b 45 08             	mov    0x8(%ebp),%eax
801042b1:	05 38 02 00 00       	add    $0x238,%eax
801042b6:	83 ec 0c             	sub    $0xc,%esp
801042b9:	50                   	push   %eax
801042ba:	e8 e1 0c 00 00       	call   80104fa0 <wakeup>
801042bf:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801042c2:	8b 45 08             	mov    0x8(%ebp),%eax
801042c5:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042cb:	85 c0                	test   %eax,%eax
801042cd:	75 2c                	jne    801042fb <pipeclose+0x98>
801042cf:	8b 45 08             	mov    0x8(%ebp),%eax
801042d2:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042d8:	85 c0                	test   %eax,%eax
801042da:	75 1f                	jne    801042fb <pipeclose+0x98>
    release(&p->lock);
801042dc:	8b 45 08             	mov    0x8(%ebp),%eax
801042df:	83 ec 0c             	sub    $0xc,%esp
801042e2:	50                   	push   %eax
801042e3:	e8 2d 0f 00 00       	call   80105215 <release>
801042e8:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801042eb:	83 ec 0c             	sub    $0xc,%esp
801042ee:	ff 75 08             	pushl  0x8(%ebp)
801042f1:	e8 4f e9 ff ff       	call   80102c45 <kfree>
801042f6:	83 c4 10             	add    $0x10,%esp
801042f9:	eb 0f                	jmp    8010430a <pipeclose+0xa7>
  } else
    release(&p->lock);
801042fb:	8b 45 08             	mov    0x8(%ebp),%eax
801042fe:	83 ec 0c             	sub    $0xc,%esp
80104301:	50                   	push   %eax
80104302:	e8 0e 0f 00 00       	call   80105215 <release>
80104307:	83 c4 10             	add    $0x10,%esp
}
8010430a:	90                   	nop
8010430b:	c9                   	leave  
8010430c:	c3                   	ret    

8010430d <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010430d:	55                   	push   %ebp
8010430e:	89 e5                	mov    %esp,%ebp
80104310:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104313:	8b 45 08             	mov    0x8(%ebp),%eax
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	50                   	push   %eax
8010431a:	e8 8f 0e 00 00       	call   801051ae <acquire>
8010431f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104322:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104329:	e9 ad 00 00 00       	jmp    801043db <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
8010432e:	8b 45 08             	mov    0x8(%ebp),%eax
80104331:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104337:	85 c0                	test   %eax,%eax
80104339:	74 0d                	je     80104348 <pipewrite+0x3b>
8010433b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104341:	8b 40 24             	mov    0x24(%eax),%eax
80104344:	85 c0                	test   %eax,%eax
80104346:	74 19                	je     80104361 <pipewrite+0x54>
        release(&p->lock);
80104348:	8b 45 08             	mov    0x8(%ebp),%eax
8010434b:	83 ec 0c             	sub    $0xc,%esp
8010434e:	50                   	push   %eax
8010434f:	e8 c1 0e 00 00       	call   80105215 <release>
80104354:	83 c4 10             	add    $0x10,%esp
        return -1;
80104357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010435c:	e9 a8 00 00 00       	jmp    80104409 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80104361:	8b 45 08             	mov    0x8(%ebp),%eax
80104364:	05 34 02 00 00       	add    $0x234,%eax
80104369:	83 ec 0c             	sub    $0xc,%esp
8010436c:	50                   	push   %eax
8010436d:	e8 2e 0c 00 00       	call   80104fa0 <wakeup>
80104372:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104375:	8b 45 08             	mov    0x8(%ebp),%eax
80104378:	8b 55 08             	mov    0x8(%ebp),%edx
8010437b:	81 c2 38 02 00 00    	add    $0x238,%edx
80104381:	83 ec 08             	sub    $0x8,%esp
80104384:	50                   	push   %eax
80104385:	52                   	push   %edx
80104386:	e8 2a 0b 00 00       	call   80104eb5 <sleep>
8010438b:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010438e:	8b 45 08             	mov    0x8(%ebp),%eax
80104391:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104397:	8b 45 08             	mov    0x8(%ebp),%eax
8010439a:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801043a0:	05 00 02 00 00       	add    $0x200,%eax
801043a5:	39 c2                	cmp    %eax,%edx
801043a7:	74 85                	je     8010432e <pipewrite+0x21>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801043a9:	8b 45 08             	mov    0x8(%ebp),%eax
801043ac:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043b2:	8d 48 01             	lea    0x1(%eax),%ecx
801043b5:	8b 55 08             	mov    0x8(%ebp),%edx
801043b8:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801043be:	25 ff 01 00 00       	and    $0x1ff,%eax
801043c3:	89 c1                	mov    %eax,%ecx
801043c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801043cb:	01 d0                	add    %edx,%eax
801043cd:	0f b6 10             	movzbl (%eax),%edx
801043d0:	8b 45 08             	mov    0x8(%ebp),%eax
801043d3:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
801043d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043de:	3b 45 10             	cmp    0x10(%ebp),%eax
801043e1:	7c ab                	jl     8010438e <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801043e3:	8b 45 08             	mov    0x8(%ebp),%eax
801043e6:	05 34 02 00 00       	add    $0x234,%eax
801043eb:	83 ec 0c             	sub    $0xc,%esp
801043ee:	50                   	push   %eax
801043ef:	e8 ac 0b 00 00       	call   80104fa0 <wakeup>
801043f4:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043f7:	8b 45 08             	mov    0x8(%ebp),%eax
801043fa:	83 ec 0c             	sub    $0xc,%esp
801043fd:	50                   	push   %eax
801043fe:	e8 12 0e 00 00       	call   80105215 <release>
80104403:	83 c4 10             	add    $0x10,%esp
  return n;
80104406:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104409:	c9                   	leave  
8010440a:	c3                   	ret    

8010440b <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010440b:	55                   	push   %ebp
8010440c:	89 e5                	mov    %esp,%ebp
8010440e:	53                   	push   %ebx
8010440f:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104412:	8b 45 08             	mov    0x8(%ebp),%eax
80104415:	83 ec 0c             	sub    $0xc,%esp
80104418:	50                   	push   %eax
80104419:	e8 90 0d 00 00       	call   801051ae <acquire>
8010441e:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104421:	eb 3f                	jmp    80104462 <piperead+0x57>
    if(proc->killed){
80104423:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104429:	8b 40 24             	mov    0x24(%eax),%eax
8010442c:	85 c0                	test   %eax,%eax
8010442e:	74 19                	je     80104449 <piperead+0x3e>
      release(&p->lock);
80104430:	8b 45 08             	mov    0x8(%ebp),%eax
80104433:	83 ec 0c             	sub    $0xc,%esp
80104436:	50                   	push   %eax
80104437:	e8 d9 0d 00 00       	call   80105215 <release>
8010443c:	83 c4 10             	add    $0x10,%esp
      return -1;
8010443f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104444:	e9 bf 00 00 00       	jmp    80104508 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104449:	8b 45 08             	mov    0x8(%ebp),%eax
8010444c:	8b 55 08             	mov    0x8(%ebp),%edx
8010444f:	81 c2 34 02 00 00    	add    $0x234,%edx
80104455:	83 ec 08             	sub    $0x8,%esp
80104458:	50                   	push   %eax
80104459:	52                   	push   %edx
8010445a:	e8 56 0a 00 00       	call   80104eb5 <sleep>
8010445f:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104462:	8b 45 08             	mov    0x8(%ebp),%eax
80104465:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010446b:	8b 45 08             	mov    0x8(%ebp),%eax
8010446e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104474:	39 c2                	cmp    %eax,%edx
80104476:	75 0d                	jne    80104485 <piperead+0x7a>
80104478:	8b 45 08             	mov    0x8(%ebp),%eax
8010447b:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104481:	85 c0                	test   %eax,%eax
80104483:	75 9e                	jne    80104423 <piperead+0x18>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104485:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010448c:	eb 49                	jmp    801044d7 <piperead+0xcc>
    if(p->nread == p->nwrite)
8010448e:	8b 45 08             	mov    0x8(%ebp),%eax
80104491:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104497:	8b 45 08             	mov    0x8(%ebp),%eax
8010449a:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801044a0:	39 c2                	cmp    %eax,%edx
801044a2:	74 3d                	je     801044e1 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801044a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044aa:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801044ad:	8b 45 08             	mov    0x8(%ebp),%eax
801044b0:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801044b6:	8d 48 01             	lea    0x1(%eax),%ecx
801044b9:	8b 55 08             	mov    0x8(%ebp),%edx
801044bc:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801044c2:	25 ff 01 00 00       	and    $0x1ff,%eax
801044c7:	89 c2                	mov    %eax,%edx
801044c9:	8b 45 08             	mov    0x8(%ebp),%eax
801044cc:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801044d1:	88 03                	mov    %al,(%ebx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044da:	3b 45 10             	cmp    0x10(%ebp),%eax
801044dd:	7c af                	jl     8010448e <piperead+0x83>
801044df:	eb 01                	jmp    801044e2 <piperead+0xd7>
      break;
801044e1:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801044e2:	8b 45 08             	mov    0x8(%ebp),%eax
801044e5:	05 38 02 00 00       	add    $0x238,%eax
801044ea:	83 ec 0c             	sub    $0xc,%esp
801044ed:	50                   	push   %eax
801044ee:	e8 ad 0a 00 00       	call   80104fa0 <wakeup>
801044f3:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044f6:	8b 45 08             	mov    0x8(%ebp),%eax
801044f9:	83 ec 0c             	sub    $0xc,%esp
801044fc:	50                   	push   %eax
801044fd:	e8 13 0d 00 00       	call   80105215 <release>
80104502:	83 c4 10             	add    $0x10,%esp
  return i;
80104505:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104508:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010450b:	c9                   	leave  
8010450c:	c3                   	ret    

8010450d <readeflags>:
{
8010450d:	55                   	push   %ebp
8010450e:	89 e5                	mov    %esp,%ebp
80104510:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104513:	9c                   	pushf  
80104514:	58                   	pop    %eax
80104515:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104518:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010451b:	c9                   	leave  
8010451c:	c3                   	ret    

8010451d <sti>:
{
8010451d:	55                   	push   %ebp
8010451e:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104520:	fb                   	sti    
}
80104521:	90                   	nop
80104522:	5d                   	pop    %ebp
80104523:	c3                   	ret    

80104524 <hlt>:
{
80104524:	55                   	push   %ebp
80104525:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
80104527:	f4                   	hlt    
}
80104528:	90                   	nop
80104529:	5d                   	pop    %ebp
8010452a:	c3                   	ret    

8010452b <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010452b:	55                   	push   %ebp
8010452c:	89 e5                	mov    %esp,%ebp
8010452e:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104531:	83 ec 08             	sub    $0x8,%esp
80104534:	68 cd 8c 10 80       	push   $0x80108ccd
80104539:	68 60 43 11 80       	push   $0x80114360
8010453e:	e8 49 0c 00 00       	call   8010518c <initlock>
80104543:	83 c4 10             	add    $0x10,%esp
  // Seed RNG with current time
  sgenrand(unixtime());
80104546:	e8 60 ee ff ff       	call   801033ab <unixtime>
8010454b:	83 ec 0c             	sub    $0xc,%esp
8010454e:	50                   	push   %eax
8010454f:	e8 a7 33 00 00       	call   801078fb <sgenrand>
80104554:	83 c4 10             	add    $0x10,%esp
}
80104557:	90                   	nop
80104558:	c9                   	leave  
80104559:	c3                   	ret    

8010455a <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010455a:	55                   	push   %ebp
8010455b:	89 e5                	mov    %esp,%ebp
8010455d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104560:	83 ec 0c             	sub    $0xc,%esp
80104563:	68 60 43 11 80       	push   $0x80114360
80104568:	e8 41 0c 00 00       	call   801051ae <acquire>
8010456d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104570:	c7 45 f4 94 43 11 80 	movl   $0x80114394,-0xc(%ebp)
80104577:	eb 0e                	jmp    80104587 <allocproc+0x2d>
    if(p->state == UNUSED)
80104579:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457c:	8b 40 0c             	mov    0xc(%eax),%eax
8010457f:	85 c0                	test   %eax,%eax
80104581:	74 27                	je     801045aa <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104583:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104587:	81 7d f4 94 63 11 80 	cmpl   $0x80116394,-0xc(%ebp)
8010458e:	72 e9                	jb     80104579 <allocproc+0x1f>
      goto found;
  release(&ptable.lock);
80104590:	83 ec 0c             	sub    $0xc,%esp
80104593:	68 60 43 11 80       	push   $0x80114360
80104598:	e8 78 0c 00 00       	call   80105215 <release>
8010459d:	83 c4 10             	add    $0x10,%esp
  return 0;
801045a0:	b8 00 00 00 00       	mov    $0x0,%eax
801045a5:	e9 be 00 00 00       	jmp    80104668 <allocproc+0x10e>
      goto found;
801045aa:	90                   	nop

found:
  p->state = EMBRYO;
801045ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ae:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801045b5:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801045ba:	8d 50 01             	lea    0x1(%eax),%edx
801045bd:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801045c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045c6:	89 42 10             	mov    %eax,0x10(%edx)
  p->tickets = INIT_TICKETS;
801045c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045cc:	c7 40 7c 0a 00 00 00 	movl   $0xa,0x7c(%eax)
  release(&ptable.lock);
801045d3:	83 ec 0c             	sub    $0xc,%esp
801045d6:	68 60 43 11 80       	push   $0x80114360
801045db:	e8 35 0c 00 00       	call   80105215 <release>
801045e0:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801045e3:	e8 fa e6 ff ff       	call   80102ce2 <kalloc>
801045e8:	89 c2                	mov    %eax,%edx
801045ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ed:	89 50 08             	mov    %edx,0x8(%eax)
801045f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f3:	8b 40 08             	mov    0x8(%eax),%eax
801045f6:	85 c0                	test   %eax,%eax
801045f8:	75 11                	jne    8010460b <allocproc+0xb1>
    p->state = UNUSED;
801045fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104604:	b8 00 00 00 00       	mov    $0x0,%eax
80104609:	eb 5d                	jmp    80104668 <allocproc+0x10e>
  }
  sp = p->kstack + KSTACKSIZE;
8010460b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460e:	8b 40 08             	mov    0x8(%eax),%eax
80104611:	05 00 10 00 00       	add    $0x1000,%eax
80104616:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104619:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010461d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104620:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104623:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104626:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010462a:	ba 58 68 10 80       	mov    $0x80106858,%edx
8010462f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104632:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104634:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010463e:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104644:	8b 40 1c             	mov    0x1c(%eax),%eax
80104647:	83 ec 04             	sub    $0x4,%esp
8010464a:	6a 14                	push   $0x14
8010464c:	6a 00                	push   $0x0
8010464e:	50                   	push   %eax
8010464f:	e8 bd 0d 00 00       	call   80105411 <memset>
80104654:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104657:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010465d:	ba 6f 4e 10 80       	mov    $0x80104e6f,%edx
80104662:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104665:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104668:	c9                   	leave  
80104669:	c3                   	ret    

8010466a <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010466a:	55                   	push   %ebp
8010466b:	89 e5                	mov    %esp,%ebp
8010466d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104670:	e8 e5 fe ff ff       	call   8010455a <allocproc>
80104675:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104678:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467b:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
80104680:	e8 da 3a 00 00       	call   8010815f <setupkvm>
80104685:	89 c2                	mov    %eax,%edx
80104687:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468a:	89 50 04             	mov    %edx,0x4(%eax)
8010468d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104690:	8b 40 04             	mov    0x4(%eax),%eax
80104693:	85 c0                	test   %eax,%eax
80104695:	75 0d                	jne    801046a4 <userinit+0x3a>
    panic("userinit: out of memory?");
80104697:	83 ec 0c             	sub    $0xc,%esp
8010469a:	68 d4 8c 10 80       	push   $0x80108cd4
8010469f:	e8 3e bf ff ff       	call   801005e2 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801046a4:	ba 2c 00 00 00       	mov    $0x2c,%edx
801046a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ac:	8b 40 04             	mov    0x4(%eax),%eax
801046af:	83 ec 04             	sub    $0x4,%esp
801046b2:	52                   	push   %edx
801046b3:	68 00 c5 10 80       	push   $0x8010c500
801046b8:	50                   	push   %eax
801046b9:	e8 fb 3c 00 00       	call   801083b9 <inituvm>
801046be:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801046c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c4:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801046ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046cd:	8b 40 18             	mov    0x18(%eax),%eax
801046d0:	83 ec 04             	sub    $0x4,%esp
801046d3:	6a 4c                	push   $0x4c
801046d5:	6a 00                	push   $0x0
801046d7:	50                   	push   %eax
801046d8:	e8 34 0d 00 00       	call   80105411 <memset>
801046dd:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801046e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e3:	8b 40 18             	mov    0x18(%eax),%eax
801046e6:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801046ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ef:	8b 40 18             	mov    0x18(%eax),%eax
801046f2:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801046f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046fb:	8b 40 18             	mov    0x18(%eax),%eax
801046fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104701:	8b 52 18             	mov    0x18(%edx),%edx
80104704:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104708:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010470c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470f:	8b 40 18             	mov    0x18(%eax),%eax
80104712:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104715:	8b 52 18             	mov    0x18(%edx),%edx
80104718:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010471c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104723:	8b 40 18             	mov    0x18(%eax),%eax
80104726:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010472d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104730:	8b 40 18             	mov    0x18(%eax),%eax
80104733:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010473a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473d:	8b 40 18             	mov    0x18(%eax),%eax
80104740:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474a:	83 c0 6c             	add    $0x6c,%eax
8010474d:	83 ec 04             	sub    $0x4,%esp
80104750:	6a 10                	push   $0x10
80104752:	68 ed 8c 10 80       	push   $0x80108ced
80104757:	50                   	push   %eax
80104758:	e8 b7 0e 00 00       	call   80105614 <safestrcpy>
8010475d:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104760:	83 ec 0c             	sub    $0xc,%esp
80104763:	68 f6 8c 10 80       	push   $0x80108cf6
80104768:	e8 37 de ff ff       	call   801025a4 <namei>
8010476d:	83 c4 10             	add    $0x10,%esp
80104770:	89 c2                	mov    %eax,%edx
80104772:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104775:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
80104778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010477b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  p->tickets = INIT_TICKETS;
80104782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104785:	c7 40 7c 0a 00 00 00 	movl   $0xa,0x7c(%eax)
}
8010478c:	90                   	nop
8010478d:	c9                   	leave  
8010478e:	c3                   	ret    

8010478f <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010478f:	55                   	push   %ebp
80104790:	89 e5                	mov    %esp,%ebp
80104792:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104795:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010479b:	8b 00                	mov    (%eax),%eax
8010479d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801047a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801047a4:	7e 31                	jle    801047d7 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801047a6:	8b 55 08             	mov    0x8(%ebp),%edx
801047a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ac:	01 c2                	add    %eax,%edx
801047ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b4:	8b 40 04             	mov    0x4(%eax),%eax
801047b7:	83 ec 04             	sub    $0x4,%esp
801047ba:	52                   	push   %edx
801047bb:	ff 75 f4             	pushl  -0xc(%ebp)
801047be:	50                   	push   %eax
801047bf:	e8 42 3d 00 00       	call   80108506 <allocuvm>
801047c4:	83 c4 10             	add    $0x10,%esp
801047c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047ce:	75 3e                	jne    8010480e <growproc+0x7f>
      return -1;
801047d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d5:	eb 59                	jmp    80104830 <growproc+0xa1>
  } else if(n < 0){
801047d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801047db:	79 31                	jns    8010480e <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801047dd:	8b 55 08             	mov    0x8(%ebp),%edx
801047e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e3:	01 c2                	add    %eax,%edx
801047e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047eb:	8b 40 04             	mov    0x4(%eax),%eax
801047ee:	83 ec 04             	sub    $0x4,%esp
801047f1:	52                   	push   %edx
801047f2:	ff 75 f4             	pushl  -0xc(%ebp)
801047f5:	50                   	push   %eax
801047f6:	e8 d4 3d 00 00       	call   801085cf <deallocuvm>
801047fb:	83 c4 10             	add    $0x10,%esp
801047fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104805:	75 07                	jne    8010480e <growproc+0x7f>
      return -1;
80104807:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010480c:	eb 22                	jmp    80104830 <growproc+0xa1>
  }
  proc->sz = sz;
8010480e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104814:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104817:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104819:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010481f:	83 ec 0c             	sub    $0xc,%esp
80104822:	50                   	push   %eax
80104823:	e8 1e 3a 00 00       	call   80108246 <switchuvm>
80104828:	83 c4 10             	add    $0x10,%esp
  return 0;
8010482b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104830:	c9                   	leave  
80104831:	c3                   	ret    

80104832 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104832:	55                   	push   %ebp
80104833:	89 e5                	mov    %esp,%ebp
80104835:	57                   	push   %edi
80104836:	56                   	push   %esi
80104837:	53                   	push   %ebx
80104838:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010483b:	e8 1a fd ff ff       	call   8010455a <allocproc>
80104840:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104843:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104847:	75 0a                	jne    80104853 <fork+0x21>
    return -1;
80104849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010484e:	e9 68 01 00 00       	jmp    801049bb <fork+0x189>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104853:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104859:	8b 10                	mov    (%eax),%edx
8010485b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104861:	8b 40 04             	mov    0x4(%eax),%eax
80104864:	83 ec 08             	sub    $0x8,%esp
80104867:	52                   	push   %edx
80104868:	50                   	push   %eax
80104869:	e8 ff 3e 00 00       	call   8010876d <copyuvm>
8010486e:	83 c4 10             	add    $0x10,%esp
80104871:	89 c2                	mov    %eax,%edx
80104873:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104876:	89 50 04             	mov    %edx,0x4(%eax)
80104879:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010487c:	8b 40 04             	mov    0x4(%eax),%eax
8010487f:	85 c0                	test   %eax,%eax
80104881:	75 30                	jne    801048b3 <fork+0x81>
    kfree(np->kstack);
80104883:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104886:	8b 40 08             	mov    0x8(%eax),%eax
80104889:	83 ec 0c             	sub    $0xc,%esp
8010488c:	50                   	push   %eax
8010488d:	e8 b3 e3 ff ff       	call   80102c45 <kfree>
80104892:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104895:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104898:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010489f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048a2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801048a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048ae:	e9 08 01 00 00       	jmp    801049bb <fork+0x189>
  }
  np->sz = proc->sz;
801048b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b9:	8b 10                	mov    (%eax),%edx
801048bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048be:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801048c0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048ca:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801048cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048d0:	8b 50 18             	mov    0x18(%eax),%edx
801048d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d9:	8b 40 18             	mov    0x18(%eax),%eax
801048dc:	89 c3                	mov    %eax,%ebx
801048de:	b8 13 00 00 00       	mov    $0x13,%eax
801048e3:	89 d7                	mov    %edx,%edi
801048e5:	89 de                	mov    %ebx,%esi
801048e7:	89 c1                	mov    %eax,%ecx
801048e9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801048eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048ee:	8b 40 18             	mov    0x18(%eax),%eax
801048f1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801048f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801048ff:	eb 43                	jmp    80104944 <fork+0x112>
    if(proc->ofile[i])
80104901:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104907:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010490a:	83 c2 08             	add    $0x8,%edx
8010490d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104911:	85 c0                	test   %eax,%eax
80104913:	74 2b                	je     80104940 <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
80104915:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010491e:	83 c2 08             	add    $0x8,%edx
80104921:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104925:	83 ec 0c             	sub    $0xc,%esp
80104928:	50                   	push   %eax
80104929:	e8 4e c7 ff ff       	call   8010107c <filedup>
8010492e:	83 c4 10             	add    $0x10,%esp
80104931:	89 c1                	mov    %eax,%ecx
80104933:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104936:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104939:	83 c2 08             	add    $0x8,%edx
8010493c:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  for(i = 0; i < NOFILE; i++)
80104940:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104944:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104948:	7e b7                	jle    80104901 <fork+0xcf>
  np->cwd = idup(proc->cwd);
8010494a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104950:	8b 40 68             	mov    0x68(%eax),%eax
80104953:	83 ec 0c             	sub    $0xc,%esp
80104956:	50                   	push   %eax
80104957:	e8 50 d0 ff ff       	call   801019ac <idup>
8010495c:	83 c4 10             	add    $0x10,%esp
8010495f:	89 c2                	mov    %eax,%edx
80104961:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104964:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104967:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010496d:	8d 50 6c             	lea    0x6c(%eax),%edx
80104970:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104973:	83 c0 6c             	add    $0x6c,%eax
80104976:	83 ec 04             	sub    $0x4,%esp
80104979:	6a 10                	push   $0x10
8010497b:	52                   	push   %edx
8010497c:	50                   	push   %eax
8010497d:	e8 92 0c 00 00       	call   80105614 <safestrcpy>
80104982:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104985:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104988:	8b 40 10             	mov    0x10(%eax),%eax
8010498b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010498e:	83 ec 0c             	sub    $0xc,%esp
80104991:	68 60 43 11 80       	push   $0x80114360
80104996:	e8 13 08 00 00       	call   801051ae <acquire>
8010499b:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
8010499e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049a1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801049a8:	83 ec 0c             	sub    $0xc,%esp
801049ab:	68 60 43 11 80       	push   $0x80114360
801049b0:	e8 60 08 00 00       	call   80105215 <release>
801049b5:	83 c4 10             	add    $0x10,%esp
  
  return pid;
801049b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801049bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049be:	5b                   	pop    %ebx
801049bf:	5e                   	pop    %esi
801049c0:	5f                   	pop    %edi
801049c1:	5d                   	pop    %ebp
801049c2:	c3                   	ret    

801049c3 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801049c3:	55                   	push   %ebp
801049c4:	89 e5                	mov    %esp,%ebp
801049c6:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801049c9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049d0:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801049d5:	39 c2                	cmp    %eax,%edx
801049d7:	75 0d                	jne    801049e6 <exit+0x23>
    panic("init exiting");
801049d9:	83 ec 0c             	sub    $0xc,%esp
801049dc:	68 f8 8c 10 80       	push   $0x80108cf8
801049e1:	e8 fc bb ff ff       	call   801005e2 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801049e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801049ed:	eb 48                	jmp    80104a37 <exit+0x74>
    if(proc->ofile[fd]){
801049ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049f8:	83 c2 08             	add    $0x8,%edx
801049fb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049ff:	85 c0                	test   %eax,%eax
80104a01:	74 30                	je     80104a33 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104a03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a09:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a0c:	83 c2 08             	add    $0x8,%edx
80104a0f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a13:	83 ec 0c             	sub    $0xc,%esp
80104a16:	50                   	push   %eax
80104a17:	e8 b1 c6 ff ff       	call   801010cd <fileclose>
80104a1c:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104a1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a25:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a28:	83 c2 08             	add    $0x8,%edx
80104a2b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104a32:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104a33:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a37:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104a3b:	7e b2                	jle    801049ef <exit+0x2c>
    }
  }

  begin_op();
80104a3d:	e8 da eb ff ff       	call   8010361c <begin_op>
  iput(proc->cwd);
80104a42:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a48:	8b 40 68             	mov    0x68(%eax),%eax
80104a4b:	83 ec 0c             	sub    $0xc,%esp
80104a4e:	50                   	push   %eax
80104a4f:	e8 62 d1 ff ff       	call   80101bb6 <iput>
80104a54:	83 c4 10             	add    $0x10,%esp
  end_op();
80104a57:	e8 4c ec ff ff       	call   801036a8 <end_op>
  proc->cwd = 0;
80104a5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a62:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104a69:	83 ec 0c             	sub    $0xc,%esp
80104a6c:	68 60 43 11 80       	push   $0x80114360
80104a71:	e8 38 07 00 00       	call   801051ae <acquire>
80104a76:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104a79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7f:	8b 40 14             	mov    0x14(%eax),%eax
80104a82:	83 ec 0c             	sub    $0xc,%esp
80104a85:	50                   	push   %eax
80104a86:	e8 d6 04 00 00       	call   80104f61 <wakeup1>
80104a8b:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a8e:	c7 45 f4 94 43 11 80 	movl   $0x80114394,-0xc(%ebp)
80104a95:	eb 3c                	jmp    80104ad3 <exit+0x110>
    if(p->parent == proc){
80104a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a9a:	8b 50 14             	mov    0x14(%eax),%edx
80104a9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa3:	39 c2                	cmp    %eax,%edx
80104aa5:	75 28                	jne    80104acf <exit+0x10c>
      p->parent = initproc;
80104aa7:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab0:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab6:	8b 40 0c             	mov    0xc(%eax),%eax
80104ab9:	83 f8 05             	cmp    $0x5,%eax
80104abc:	75 11                	jne    80104acf <exit+0x10c>
        wakeup1(initproc);
80104abe:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104ac3:	83 ec 0c             	sub    $0xc,%esp
80104ac6:	50                   	push   %eax
80104ac7:	e8 95 04 00 00       	call   80104f61 <wakeup1>
80104acc:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104acf:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104ad3:	81 7d f4 94 63 11 80 	cmpl   $0x80116394,-0xc(%ebp)
80104ada:	72 bb                	jb     80104a97 <exit+0xd4>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104adc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae2:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104ae9:	e8 8a 02 00 00       	call   80104d78 <sched>
  panic("zombie exit");
80104aee:	83 ec 0c             	sub    $0xc,%esp
80104af1:	68 05 8d 10 80       	push   $0x80108d05
80104af6:	e8 e7 ba ff ff       	call   801005e2 <panic>

80104afb <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104afb:	55                   	push   %ebp
80104afc:	89 e5                	mov    %esp,%ebp
80104afe:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b01:	83 ec 0c             	sub    $0xc,%esp
80104b04:	68 60 43 11 80       	push   $0x80114360
80104b09:	e8 a0 06 00 00       	call   801051ae <acquire>
80104b0e:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b11:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b18:	c7 45 f4 94 43 11 80 	movl   $0x80114394,-0xc(%ebp)
80104b1f:	e9 a6 00 00 00       	jmp    80104bca <wait+0xcf>
      if(p->parent != proc)
80104b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b27:	8b 50 14             	mov    0x14(%eax),%edx
80104b2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b30:	39 c2                	cmp    %eax,%edx
80104b32:	0f 85 8d 00 00 00    	jne    80104bc5 <wait+0xca>
        continue;
      havekids = 1;
80104b38:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b42:	8b 40 0c             	mov    0xc(%eax),%eax
80104b45:	83 f8 05             	cmp    $0x5,%eax
80104b48:	75 7c                	jne    80104bc6 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b4d:	8b 40 10             	mov    0x10(%eax),%eax
80104b50:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b56:	8b 40 08             	mov    0x8(%eax),%eax
80104b59:	83 ec 0c             	sub    $0xc,%esp
80104b5c:	50                   	push   %eax
80104b5d:	e8 e3 e0 ff ff       	call   80102c45 <kfree>
80104b62:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b72:	8b 40 04             	mov    0x4(%eax),%eax
80104b75:	83 ec 0c             	sub    $0xc,%esp
80104b78:	50                   	push   %eax
80104b79:	e8 0e 3b 00 00       	call   8010868c <freevm>
80104b7e:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b84:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b8e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b98:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba2:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba9:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104bb0:	83 ec 0c             	sub    $0xc,%esp
80104bb3:	68 60 43 11 80       	push   $0x80114360
80104bb8:	e8 58 06 00 00       	call   80105215 <release>
80104bbd:	83 c4 10             	add    $0x10,%esp
        return pid;
80104bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bc3:	eb 58                	jmp    80104c1d <wait+0x122>
        continue;
80104bc5:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bc6:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104bca:	81 7d f4 94 63 11 80 	cmpl   $0x80116394,-0xc(%ebp)
80104bd1:	0f 82 4d ff ff ff    	jb     80104b24 <wait+0x29>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104bd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104bdb:	74 0d                	je     80104bea <wait+0xef>
80104bdd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104be3:	8b 40 24             	mov    0x24(%eax),%eax
80104be6:	85 c0                	test   %eax,%eax
80104be8:	74 17                	je     80104c01 <wait+0x106>
      release(&ptable.lock);
80104bea:	83 ec 0c             	sub    $0xc,%esp
80104bed:	68 60 43 11 80       	push   $0x80114360
80104bf2:	e8 1e 06 00 00       	call   80105215 <release>
80104bf7:	83 c4 10             	add    $0x10,%esp
      return -1;
80104bfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bff:	eb 1c                	jmp    80104c1d <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104c01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c07:	83 ec 08             	sub    $0x8,%esp
80104c0a:	68 60 43 11 80       	push   $0x80114360
80104c0f:	50                   	push   %eax
80104c10:	e8 a0 02 00 00       	call   80104eb5 <sleep>
80104c15:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104c18:	e9 f4 fe ff ff       	jmp    80104b11 <wait+0x16>
  }
}
80104c1d:	c9                   	leave  
80104c1e:	c3                   	ret    

80104c1f <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104c1f:	55                   	push   %ebp
80104c20:	89 e5                	mov    %esp,%ebp
80104c22:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int foundproc = 1;
80104c25:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  unsigned long rand_num;
  int sum;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104c2c:	e8 ec f8 ff ff       	call   8010451d <sti>
    total_tickets = 0;
80104c31:	c7 05 40 43 11 80 00 	movl   $0x0,0x80114340
80104c38:	00 00 00 
    for(p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104c3b:	c7 45 f4 94 43 11 80 	movl   $0x80114394,-0xc(%ebp)
80104c42:	eb 16                	jmp    80104c5a <scheduler+0x3b>
    {
 	total_tickets += p->tickets;
80104c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c47:	8b 50 7c             	mov    0x7c(%eax),%edx
80104c4a:	a1 40 43 11 80       	mov    0x80114340,%eax
80104c4f:	01 d0                	add    %edx,%eax
80104c51:	a3 40 43 11 80       	mov    %eax,0x80114340
    for(p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104c56:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104c5a:	81 7d f4 94 63 11 80 	cmpl   $0x80116394,-0xc(%ebp)
80104c61:	72 e1                	jb     80104c44 <scheduler+0x25>
    }

    rand_num = random_at_most(982343221);
80104c63:	83 ec 0c             	sub    $0xc,%esp
80104c66:	68 35 5e 8d 3a       	push   $0x3a8d5e35
80104c6b:	e8 77 2e 00 00       	call   80107ae7 <random_at_most>
80104c70:	83 c4 10             	add    $0x10,%esp
80104c73:	89 45 ec             	mov    %eax,-0x14(%ebp)
		
    if(total_tickets > 0)
80104c76:	a1 40 43 11 80       	mov    0x80114340,%eax
80104c7b:	85 c0                	test   %eax,%eax
80104c7d:	7e 16                	jle    80104c95 <scheduler+0x76>
	rand_num %= total_tickets;
80104c7f:	a1 40 43 11 80       	mov    0x80114340,%eax
80104c84:	89 c1                	mov    %eax,%ecx
80104c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c89:	ba 00 00 00 00       	mov    $0x0,%edx
80104c8e:	f7 f1                	div    %ecx
80104c90:	89 55 ec             	mov    %edx,-0x14(%ebp)
80104c93:	eb 07                	jmp    80104c9c <scheduler+0x7d>
    else
	rand_num=0;
80104c95:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

    sum = 0;
80104c9c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    if (!foundproc) hlt();
80104ca3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104ca7:	75 05                	jne    80104cae <scheduler+0x8f>
80104ca9:	e8 76 f8 ff ff       	call   80104524 <hlt>
    foundproc = 0;
80104cae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104cb5:	83 ec 0c             	sub    $0xc,%esp
80104cb8:	68 60 43 11 80       	push   $0x80114360
80104cbd:	e8 ec 04 00 00       	call   801051ae <acquire>
80104cc2:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cc5:	c7 45 f4 94 43 11 80 	movl   $0x80114394,-0xc(%ebp)
80104ccc:	e9 85 00 00 00       	jmp    80104d56 <scheduler+0x137>
      if(p->state != RUNNABLE)
80104cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd4:	8b 40 0c             	mov    0xc(%eax),%eax
80104cd7:	83 f8 03             	cmp    $0x3,%eax
80104cda:	75 75                	jne    80104d51 <scheduler+0x132>
        continue;
			
      if(p->tickets + sum <= rand_num)
80104cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cdf:	8b 50 7c             	mov    0x7c(%eax),%edx
80104ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104ce5:	01 d0                	add    %edx,%eax
80104ce7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104cea:	77 0b                	ja     80104cf7 <scheduler+0xd8>
      {
	sum += p->tickets;
80104cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cef:	8b 40 7c             	mov    0x7c(%eax),%eax
80104cf2:	01 45 e8             	add    %eax,-0x18(%ebp)
	continue;
80104cf5:	eb 5b                	jmp    80104d52 <scheduler+0x133>
      }
	
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      foundproc = 1;
80104cf7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      proc = p;
80104cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d01:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104d07:	83 ec 0c             	sub    $0xc,%esp
80104d0a:	ff 75 f4             	pushl  -0xc(%ebp)
80104d0d:	e8 34 35 00 00       	call   80108246 <switchuvm>
80104d12:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d18:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104d1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d25:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d28:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d2f:	83 c2 04             	add    $0x4,%edx
80104d32:	83 ec 08             	sub    $0x8,%esp
80104d35:	50                   	push   %eax
80104d36:	52                   	push   %edx
80104d37:	e8 49 09 00 00       	call   80105685 <swtch>
80104d3c:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104d3f:	e8 e5 34 00 00       	call   80108229 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104d44:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104d4b:	00 00 00 00 
      break;
80104d4f:	eb 12                	jmp    80104d63 <scheduler+0x144>
        continue;
80104d51:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d52:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104d56:	81 7d f4 94 63 11 80 	cmpl   $0x80116394,-0xc(%ebp)
80104d5d:	0f 82 6e ff ff ff    	jb     80104cd1 <scheduler+0xb2>
    }
    release(&ptable.lock);
80104d63:	83 ec 0c             	sub    $0xc,%esp
80104d66:	68 60 43 11 80       	push   $0x80114360
80104d6b:	e8 a5 04 00 00       	call   80105215 <release>
80104d70:	83 c4 10             	add    $0x10,%esp
    sti();
80104d73:	e9 b4 fe ff ff       	jmp    80104c2c <scheduler+0xd>

80104d78 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104d78:	55                   	push   %ebp
80104d79:	89 e5                	mov    %esp,%ebp
80104d7b:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d7e:	83 ec 0c             	sub    $0xc,%esp
80104d81:	68 60 43 11 80       	push   $0x80114360
80104d86:	e8 56 05 00 00       	call   801052e1 <holding>
80104d8b:	83 c4 10             	add    $0x10,%esp
80104d8e:	85 c0                	test   %eax,%eax
80104d90:	75 0d                	jne    80104d9f <sched+0x27>
    panic("sched ptable.lock");
80104d92:	83 ec 0c             	sub    $0xc,%esp
80104d95:	68 11 8d 10 80       	push   $0x80108d11
80104d9a:	e8 43 b8 ff ff       	call   801005e2 <panic>
  if(cpu->ncli != 1)
80104d9f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104da5:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104dab:	83 f8 01             	cmp    $0x1,%eax
80104dae:	74 0d                	je     80104dbd <sched+0x45>
    panic("sched locks");
80104db0:	83 ec 0c             	sub    $0xc,%esp
80104db3:	68 23 8d 10 80       	push   $0x80108d23
80104db8:	e8 25 b8 ff ff       	call   801005e2 <panic>
  if(proc->state == RUNNING)
80104dbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc3:	8b 40 0c             	mov    0xc(%eax),%eax
80104dc6:	83 f8 04             	cmp    $0x4,%eax
80104dc9:	75 0d                	jne    80104dd8 <sched+0x60>
    panic("sched running");
80104dcb:	83 ec 0c             	sub    $0xc,%esp
80104dce:	68 2f 8d 10 80       	push   $0x80108d2f
80104dd3:	e8 0a b8 ff ff       	call   801005e2 <panic>
  if(readeflags()&FL_IF)
80104dd8:	e8 30 f7 ff ff       	call   8010450d <readeflags>
80104ddd:	25 00 02 00 00       	and    $0x200,%eax
80104de2:	85 c0                	test   %eax,%eax
80104de4:	74 0d                	je     80104df3 <sched+0x7b>
    panic("sched interruptible");
80104de6:	83 ec 0c             	sub    $0xc,%esp
80104de9:	68 3d 8d 10 80       	push   $0x80108d3d
80104dee:	e8 ef b7 ff ff       	call   801005e2 <panic>
  intena = cpu->intena;
80104df3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104df9:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104e02:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e08:	8b 40 04             	mov    0x4(%eax),%eax
80104e0b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e12:	83 c2 1c             	add    $0x1c,%edx
80104e15:	83 ec 08             	sub    $0x8,%esp
80104e18:	50                   	push   %eax
80104e19:	52                   	push   %edx
80104e1a:	e8 66 08 00 00       	call   80105685 <swtch>
80104e1f:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104e22:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e2b:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104e31:	90                   	nop
80104e32:	c9                   	leave  
80104e33:	c3                   	ret    

80104e34 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104e3a:	83 ec 0c             	sub    $0xc,%esp
80104e3d:	68 60 43 11 80       	push   $0x80114360
80104e42:	e8 67 03 00 00       	call   801051ae <acquire>
80104e47:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104e4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e50:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104e57:	e8 1c ff ff ff       	call   80104d78 <sched>
  release(&ptable.lock);
80104e5c:	83 ec 0c             	sub    $0xc,%esp
80104e5f:	68 60 43 11 80       	push   $0x80114360
80104e64:	e8 ac 03 00 00       	call   80105215 <release>
80104e69:	83 c4 10             	add    $0x10,%esp
}
80104e6c:	90                   	nop
80104e6d:	c9                   	leave  
80104e6e:	c3                   	ret    

80104e6f <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104e6f:	55                   	push   %ebp
80104e70:	89 e5                	mov    %esp,%ebp
80104e72:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104e75:	83 ec 0c             	sub    $0xc,%esp
80104e78:	68 60 43 11 80       	push   $0x80114360
80104e7d:	e8 93 03 00 00       	call   80105215 <release>
80104e82:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104e85:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104e8a:	85 c0                	test   %eax,%eax
80104e8c:	74 24                	je     80104eb2 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104e8e:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104e95:	00 00 00 
    iinit(ROOTDEV);
80104e98:	83 ec 0c             	sub    $0xc,%esp
80104e9b:	6a 01                	push   $0x1
80104e9d:	e8 18 c8 ff ff       	call   801016ba <iinit>
80104ea2:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104ea5:	83 ec 0c             	sub    $0xc,%esp
80104ea8:	6a 01                	push   $0x1
80104eaa:	e8 4f e5 ff ff       	call   801033fe <initlog>
80104eaf:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104eb2:	90                   	nop
80104eb3:	c9                   	leave  
80104eb4:	c3                   	ret    

80104eb5 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104eb5:	55                   	push   %ebp
80104eb6:	89 e5                	mov    %esp,%ebp
80104eb8:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104ebb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ec1:	85 c0                	test   %eax,%eax
80104ec3:	75 0d                	jne    80104ed2 <sleep+0x1d>
    panic("sleep");
80104ec5:	83 ec 0c             	sub    $0xc,%esp
80104ec8:	68 51 8d 10 80       	push   $0x80108d51
80104ecd:	e8 10 b7 ff ff       	call   801005e2 <panic>

  if(lk == 0)
80104ed2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104ed6:	75 0d                	jne    80104ee5 <sleep+0x30>
    panic("sleep without lk");
80104ed8:	83 ec 0c             	sub    $0xc,%esp
80104edb:	68 57 8d 10 80       	push   $0x80108d57
80104ee0:	e8 fd b6 ff ff       	call   801005e2 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ee5:	81 7d 0c 60 43 11 80 	cmpl   $0x80114360,0xc(%ebp)
80104eec:	74 1e                	je     80104f0c <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104eee:	83 ec 0c             	sub    $0xc,%esp
80104ef1:	68 60 43 11 80       	push   $0x80114360
80104ef6:	e8 b3 02 00 00       	call   801051ae <acquire>
80104efb:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104efe:	83 ec 0c             	sub    $0xc,%esp
80104f01:	ff 75 0c             	pushl  0xc(%ebp)
80104f04:	e8 0c 03 00 00       	call   80105215 <release>
80104f09:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104f0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f12:	8b 55 08             	mov    0x8(%ebp),%edx
80104f15:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104f18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f1e:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104f25:	e8 4e fe ff ff       	call   80104d78 <sched>

  // Tidy up.
  proc->chan = 0;
80104f2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f30:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104f37:	81 7d 0c 60 43 11 80 	cmpl   $0x80114360,0xc(%ebp)
80104f3e:	74 1e                	je     80104f5e <sleep+0xa9>
    release(&ptable.lock);
80104f40:	83 ec 0c             	sub    $0xc,%esp
80104f43:	68 60 43 11 80       	push   $0x80114360
80104f48:	e8 c8 02 00 00       	call   80105215 <release>
80104f4d:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104f50:	83 ec 0c             	sub    $0xc,%esp
80104f53:	ff 75 0c             	pushl  0xc(%ebp)
80104f56:	e8 53 02 00 00       	call   801051ae <acquire>
80104f5b:	83 c4 10             	add    $0x10,%esp
  }
}
80104f5e:	90                   	nop
80104f5f:	c9                   	leave  
80104f60:	c3                   	ret    

80104f61 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104f61:	55                   	push   %ebp
80104f62:	89 e5                	mov    %esp,%ebp
80104f64:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f67:	c7 45 fc 94 43 11 80 	movl   $0x80114394,-0x4(%ebp)
80104f6e:	eb 24                	jmp    80104f94 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f73:	8b 40 0c             	mov    0xc(%eax),%eax
80104f76:	83 f8 02             	cmp    $0x2,%eax
80104f79:	75 15                	jne    80104f90 <wakeup1+0x2f>
80104f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f7e:	8b 40 20             	mov    0x20(%eax),%eax
80104f81:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f84:	75 0a                	jne    80104f90 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f89:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f90:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104f94:	81 7d fc 94 63 11 80 	cmpl   $0x80116394,-0x4(%ebp)
80104f9b:	72 d3                	jb     80104f70 <wakeup1+0xf>
}
80104f9d:	90                   	nop
80104f9e:	c9                   	leave  
80104f9f:	c3                   	ret    

80104fa0 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104fa6:	83 ec 0c             	sub    $0xc,%esp
80104fa9:	68 60 43 11 80       	push   $0x80114360
80104fae:	e8 fb 01 00 00       	call   801051ae <acquire>
80104fb3:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104fb6:	83 ec 0c             	sub    $0xc,%esp
80104fb9:	ff 75 08             	pushl  0x8(%ebp)
80104fbc:	e8 a0 ff ff ff       	call   80104f61 <wakeup1>
80104fc1:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104fc4:	83 ec 0c             	sub    $0xc,%esp
80104fc7:	68 60 43 11 80       	push   $0x80114360
80104fcc:	e8 44 02 00 00       	call   80105215 <release>
80104fd1:	83 c4 10             	add    $0x10,%esp
}
80104fd4:	90                   	nop
80104fd5:	c9                   	leave  
80104fd6:	c3                   	ret    

80104fd7 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104fd7:	55                   	push   %ebp
80104fd8:	89 e5                	mov    %esp,%ebp
80104fda:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104fdd:	83 ec 0c             	sub    $0xc,%esp
80104fe0:	68 60 43 11 80       	push   $0x80114360
80104fe5:	e8 c4 01 00 00       	call   801051ae <acquire>
80104fea:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fed:	c7 45 f4 94 43 11 80 	movl   $0x80114394,-0xc(%ebp)
80104ff4:	eb 45                	jmp    8010503b <kill+0x64>
    if(p->pid == pid){
80104ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff9:	8b 40 10             	mov    0x10(%eax),%eax
80104ffc:	3b 45 08             	cmp    0x8(%ebp),%eax
80104fff:	75 36                	jne    80105037 <kill+0x60>
      p->killed = 1;
80105001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105004:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010500b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010500e:	8b 40 0c             	mov    0xc(%eax),%eax
80105011:	83 f8 02             	cmp    $0x2,%eax
80105014:	75 0a                	jne    80105020 <kill+0x49>
        p->state = RUNNABLE;
80105016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105019:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	68 60 43 11 80       	push   $0x80114360
80105028:	e8 e8 01 00 00       	call   80105215 <release>
8010502d:	83 c4 10             	add    $0x10,%esp
      return 0;
80105030:	b8 00 00 00 00       	mov    $0x0,%eax
80105035:	eb 22                	jmp    80105059 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105037:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010503b:	81 7d f4 94 63 11 80 	cmpl   $0x80116394,-0xc(%ebp)
80105042:	72 b2                	jb     80104ff6 <kill+0x1f>
    }
  }
  release(&ptable.lock);
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	68 60 43 11 80       	push   $0x80114360
8010504c:	e8 c4 01 00 00       	call   80105215 <release>
80105051:	83 c4 10             	add    $0x10,%esp
  return -1;
80105054:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105059:	c9                   	leave  
8010505a:	c3                   	ret    

8010505b <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010505b:	55                   	push   %ebp
8010505c:	89 e5                	mov    %esp,%ebp
8010505e:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105061:	c7 45 f0 94 43 11 80 	movl   $0x80114394,-0x10(%ebp)
80105068:	e9 d7 00 00 00       	jmp    80105144 <procdump+0xe9>
    if(p->state == UNUSED)
8010506d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105070:	8b 40 0c             	mov    0xc(%eax),%eax
80105073:	85 c0                	test   %eax,%eax
80105075:	0f 84 c4 00 00 00    	je     8010513f <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010507b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010507e:	8b 40 0c             	mov    0xc(%eax),%eax
80105081:	83 f8 05             	cmp    $0x5,%eax
80105084:	77 23                	ja     801050a9 <procdump+0x4e>
80105086:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105089:	8b 40 0c             	mov    0xc(%eax),%eax
8010508c:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105093:	85 c0                	test   %eax,%eax
80105095:	74 12                	je     801050a9 <procdump+0x4e>
      state = states[p->state];
80105097:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010509a:	8b 40 0c             	mov    0xc(%eax),%eax
8010509d:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
801050a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801050a7:	eb 07                	jmp    801050b0 <procdump+0x55>
    else
      state = "???";
801050a9:	c7 45 ec 68 8d 10 80 	movl   $0x80108d68,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
801050b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050b3:	8d 50 6c             	lea    0x6c(%eax),%edx
801050b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050b9:	8b 40 10             	mov    0x10(%eax),%eax
801050bc:	52                   	push   %edx
801050bd:	ff 75 ec             	pushl  -0x14(%ebp)
801050c0:	50                   	push   %eax
801050c1:	68 6c 8d 10 80       	push   $0x80108d6c
801050c6:	e8 4f b3 ff ff       	call   8010041a <cprintf>
801050cb:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
801050ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050d1:	8b 40 0c             	mov    0xc(%eax),%eax
801050d4:	83 f8 02             	cmp    $0x2,%eax
801050d7:	75 54                	jne    8010512d <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801050d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050dc:	8b 40 1c             	mov    0x1c(%eax),%eax
801050df:	8b 40 0c             	mov    0xc(%eax),%eax
801050e2:	83 c0 08             	add    $0x8,%eax
801050e5:	89 c2                	mov    %eax,%edx
801050e7:	83 ec 08             	sub    $0x8,%esp
801050ea:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050ed:	50                   	push   %eax
801050ee:	52                   	push   %edx
801050ef:	e8 73 01 00 00       	call   80105267 <getcallerpcs>
801050f4:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801050f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801050fe:	eb 1c                	jmp    8010511c <procdump+0xc1>
        cprintf(" %p", pc[i]);
80105100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105103:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105107:	83 ec 08             	sub    $0x8,%esp
8010510a:	50                   	push   %eax
8010510b:	68 75 8d 10 80       	push   $0x80108d75
80105110:	e8 05 b3 ff ff       	call   8010041a <cprintf>
80105115:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105118:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010511c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105120:	7f 0b                	jg     8010512d <procdump+0xd2>
80105122:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105125:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105129:	85 c0                	test   %eax,%eax
8010512b:	75 d3                	jne    80105100 <procdump+0xa5>
    }
    cprintf("\n");
8010512d:	83 ec 0c             	sub    $0xc,%esp
80105130:	68 79 8d 10 80       	push   $0x80108d79
80105135:	e8 e0 b2 ff ff       	call   8010041a <cprintf>
8010513a:	83 c4 10             	add    $0x10,%esp
8010513d:	eb 01                	jmp    80105140 <procdump+0xe5>
      continue;
8010513f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105140:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
80105144:	81 7d f0 94 63 11 80 	cmpl   $0x80116394,-0x10(%ebp)
8010514b:	0f 82 1c ff ff ff    	jb     8010506d <procdump+0x12>
  }
}
80105151:	90                   	nop
80105152:	c9                   	leave  
80105153:	c3                   	ret    

80105154 <readeflags>:
{
80105154:	55                   	push   %ebp
80105155:	89 e5                	mov    %esp,%ebp
80105157:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010515a:	9c                   	pushf  
8010515b:	58                   	pop    %eax
8010515c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010515f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105162:	c9                   	leave  
80105163:	c3                   	ret    

80105164 <cli>:
{
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105167:	fa                   	cli    
}
80105168:	90                   	nop
80105169:	5d                   	pop    %ebp
8010516a:	c3                   	ret    

8010516b <sti>:
{
8010516b:	55                   	push   %ebp
8010516c:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010516e:	fb                   	sti    
}
8010516f:	90                   	nop
80105170:	5d                   	pop    %ebp
80105171:	c3                   	ret    

80105172 <xchg>:
{
80105172:	55                   	push   %ebp
80105173:	89 e5                	mov    %esp,%ebp
80105175:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80105178:	8b 55 08             	mov    0x8(%ebp),%edx
8010517b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010517e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105181:	f0 87 02             	lock xchg %eax,(%edx)
80105184:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80105187:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010518a:	c9                   	leave  
8010518b:	c3                   	ret    

8010518c <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010518c:	55                   	push   %ebp
8010518d:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010518f:	8b 45 08             	mov    0x8(%ebp),%eax
80105192:	8b 55 0c             	mov    0xc(%ebp),%edx
80105195:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105198:	8b 45 08             	mov    0x8(%ebp),%eax
8010519b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801051a1:	8b 45 08             	mov    0x8(%ebp),%eax
801051a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801051ab:	90                   	nop
801051ac:	5d                   	pop    %ebp
801051ad:	c3                   	ret    

801051ae <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801051ae:	55                   	push   %ebp
801051af:	89 e5                	mov    %esp,%ebp
801051b1:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801051b4:	e8 52 01 00 00       	call   8010530b <pushcli>
  if(holding(lk))
801051b9:	8b 45 08             	mov    0x8(%ebp),%eax
801051bc:	83 ec 0c             	sub    $0xc,%esp
801051bf:	50                   	push   %eax
801051c0:	e8 1c 01 00 00       	call   801052e1 <holding>
801051c5:	83 c4 10             	add    $0x10,%esp
801051c8:	85 c0                	test   %eax,%eax
801051ca:	74 0d                	je     801051d9 <acquire+0x2b>
    panic("acquire");
801051cc:	83 ec 0c             	sub    $0xc,%esp
801051cf:	68 a5 8d 10 80       	push   $0x80108da5
801051d4:	e8 09 b4 ff ff       	call   801005e2 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801051d9:	90                   	nop
801051da:	8b 45 08             	mov    0x8(%ebp),%eax
801051dd:	83 ec 08             	sub    $0x8,%esp
801051e0:	6a 01                	push   $0x1
801051e2:	50                   	push   %eax
801051e3:	e8 8a ff ff ff       	call   80105172 <xchg>
801051e8:	83 c4 10             	add    $0x10,%esp
801051eb:	85 c0                	test   %eax,%eax
801051ed:	75 eb                	jne    801051da <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801051ef:	8b 45 08             	mov    0x8(%ebp),%eax
801051f2:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801051f9:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801051fc:	8b 45 08             	mov    0x8(%ebp),%eax
801051ff:	83 c0 0c             	add    $0xc,%eax
80105202:	83 ec 08             	sub    $0x8,%esp
80105205:	50                   	push   %eax
80105206:	8d 45 08             	lea    0x8(%ebp),%eax
80105209:	50                   	push   %eax
8010520a:	e8 58 00 00 00       	call   80105267 <getcallerpcs>
8010520f:	83 c4 10             	add    $0x10,%esp
}
80105212:	90                   	nop
80105213:	c9                   	leave  
80105214:	c3                   	ret    

80105215 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105215:	55                   	push   %ebp
80105216:	89 e5                	mov    %esp,%ebp
80105218:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010521b:	83 ec 0c             	sub    $0xc,%esp
8010521e:	ff 75 08             	pushl  0x8(%ebp)
80105221:	e8 bb 00 00 00       	call   801052e1 <holding>
80105226:	83 c4 10             	add    $0x10,%esp
80105229:	85 c0                	test   %eax,%eax
8010522b:	75 0d                	jne    8010523a <release+0x25>
    panic("release");
8010522d:	83 ec 0c             	sub    $0xc,%esp
80105230:	68 ad 8d 10 80       	push   $0x80108dad
80105235:	e8 a8 b3 ff ff       	call   801005e2 <panic>

  lk->pcs[0] = 0;
8010523a:	8b 45 08             	mov    0x8(%ebp),%eax
8010523d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105244:	8b 45 08             	mov    0x8(%ebp),%eax
80105247:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010524e:	8b 45 08             	mov    0x8(%ebp),%eax
80105251:	83 ec 08             	sub    $0x8,%esp
80105254:	6a 00                	push   $0x0
80105256:	50                   	push   %eax
80105257:	e8 16 ff ff ff       	call   80105172 <xchg>
8010525c:	83 c4 10             	add    $0x10,%esp

  popcli();
8010525f:	e8 ec 00 00 00       	call   80105350 <popcli>
}
80105264:	90                   	nop
80105265:	c9                   	leave  
80105266:	c3                   	ret    

80105267 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105267:	55                   	push   %ebp
80105268:	89 e5                	mov    %esp,%ebp
8010526a:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010526d:	8b 45 08             	mov    0x8(%ebp),%eax
80105270:	83 e8 08             	sub    $0x8,%eax
80105273:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105276:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010527d:	eb 38                	jmp    801052b7 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010527f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105283:	74 53                	je     801052d8 <getcallerpcs+0x71>
80105285:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010528c:	76 4a                	jbe    801052d8 <getcallerpcs+0x71>
8010528e:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105292:	74 44                	je     801052d8 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105294:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105297:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010529e:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a1:	01 c2                	add    %eax,%edx
801052a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052a6:	8b 40 04             	mov    0x4(%eax),%eax
801052a9:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801052ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052ae:	8b 00                	mov    (%eax),%eax
801052b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801052b3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801052b7:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801052bb:	7e c2                	jle    8010527f <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
801052bd:	eb 19                	jmp    801052d8 <getcallerpcs+0x71>
    pcs[i] = 0;
801052bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801052c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801052cc:	01 d0                	add    %edx,%eax
801052ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801052d4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801052d8:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801052dc:	7e e1                	jle    801052bf <getcallerpcs+0x58>
}
801052de:	90                   	nop
801052df:	c9                   	leave  
801052e0:	c3                   	ret    

801052e1 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801052e1:	55                   	push   %ebp
801052e2:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801052e4:	8b 45 08             	mov    0x8(%ebp),%eax
801052e7:	8b 00                	mov    (%eax),%eax
801052e9:	85 c0                	test   %eax,%eax
801052eb:	74 17                	je     80105304 <holding+0x23>
801052ed:	8b 45 08             	mov    0x8(%ebp),%eax
801052f0:	8b 50 08             	mov    0x8(%eax),%edx
801052f3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052f9:	39 c2                	cmp    %eax,%edx
801052fb:	75 07                	jne    80105304 <holding+0x23>
801052fd:	b8 01 00 00 00       	mov    $0x1,%eax
80105302:	eb 05                	jmp    80105309 <holding+0x28>
80105304:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105309:	5d                   	pop    %ebp
8010530a:	c3                   	ret    

8010530b <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010530b:	55                   	push   %ebp
8010530c:	89 e5                	mov    %esp,%ebp
8010530e:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105311:	e8 3e fe ff ff       	call   80105154 <readeflags>
80105316:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105319:	e8 46 fe ff ff       	call   80105164 <cli>
  if(cpu->ncli++ == 0)
8010531e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105325:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010532b:	8d 48 01             	lea    0x1(%eax),%ecx
8010532e:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105334:	85 c0                	test   %eax,%eax
80105336:	75 15                	jne    8010534d <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105338:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010533e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105341:	81 e2 00 02 00 00    	and    $0x200,%edx
80105347:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010534d:	90                   	nop
8010534e:	c9                   	leave  
8010534f:	c3                   	ret    

80105350 <popcli>:

void
popcli(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105356:	e8 f9 fd ff ff       	call   80105154 <readeflags>
8010535b:	25 00 02 00 00       	and    $0x200,%eax
80105360:	85 c0                	test   %eax,%eax
80105362:	74 0d                	je     80105371 <popcli+0x21>
    panic("popcli - interruptible");
80105364:	83 ec 0c             	sub    $0xc,%esp
80105367:	68 b5 8d 10 80       	push   $0x80108db5
8010536c:	e8 71 b2 ff ff       	call   801005e2 <panic>
  if(--cpu->ncli < 0)
80105371:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105377:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010537d:	83 ea 01             	sub    $0x1,%edx
80105380:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105386:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010538c:	85 c0                	test   %eax,%eax
8010538e:	79 0d                	jns    8010539d <popcli+0x4d>
    panic("popcli");
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	68 cc 8d 10 80       	push   $0x80108dcc
80105398:	e8 45 b2 ff ff       	call   801005e2 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010539d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053a3:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801053a9:	85 c0                	test   %eax,%eax
801053ab:	75 15                	jne    801053c2 <popcli+0x72>
801053ad:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053b3:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801053b9:	85 c0                	test   %eax,%eax
801053bb:	74 05                	je     801053c2 <popcli+0x72>
    sti();
801053bd:	e8 a9 fd ff ff       	call   8010516b <sti>
}
801053c2:	90                   	nop
801053c3:	c9                   	leave  
801053c4:	c3                   	ret    

801053c5 <stosb>:
{
801053c5:	55                   	push   %ebp
801053c6:	89 e5                	mov    %esp,%ebp
801053c8:	57                   	push   %edi
801053c9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801053ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053cd:	8b 55 10             	mov    0x10(%ebp),%edx
801053d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801053d3:	89 cb                	mov    %ecx,%ebx
801053d5:	89 df                	mov    %ebx,%edi
801053d7:	89 d1                	mov    %edx,%ecx
801053d9:	fc                   	cld    
801053da:	f3 aa                	rep stos %al,%es:(%edi)
801053dc:	89 ca                	mov    %ecx,%edx
801053de:	89 fb                	mov    %edi,%ebx
801053e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801053e3:	89 55 10             	mov    %edx,0x10(%ebp)
}
801053e6:	90                   	nop
801053e7:	5b                   	pop    %ebx
801053e8:	5f                   	pop    %edi
801053e9:	5d                   	pop    %ebp
801053ea:	c3                   	ret    

801053eb <stosl>:
{
801053eb:	55                   	push   %ebp
801053ec:	89 e5                	mov    %esp,%ebp
801053ee:	57                   	push   %edi
801053ef:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801053f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053f3:	8b 55 10             	mov    0x10(%ebp),%edx
801053f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f9:	89 cb                	mov    %ecx,%ebx
801053fb:	89 df                	mov    %ebx,%edi
801053fd:	89 d1                	mov    %edx,%ecx
801053ff:	fc                   	cld    
80105400:	f3 ab                	rep stos %eax,%es:(%edi)
80105402:	89 ca                	mov    %ecx,%edx
80105404:	89 fb                	mov    %edi,%ebx
80105406:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105409:	89 55 10             	mov    %edx,0x10(%ebp)
}
8010540c:	90                   	nop
8010540d:	5b                   	pop    %ebx
8010540e:	5f                   	pop    %edi
8010540f:	5d                   	pop    %ebp
80105410:	c3                   	ret    

80105411 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105411:	55                   	push   %ebp
80105412:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105414:	8b 45 08             	mov    0x8(%ebp),%eax
80105417:	83 e0 03             	and    $0x3,%eax
8010541a:	85 c0                	test   %eax,%eax
8010541c:	75 43                	jne    80105461 <memset+0x50>
8010541e:	8b 45 10             	mov    0x10(%ebp),%eax
80105421:	83 e0 03             	and    $0x3,%eax
80105424:	85 c0                	test   %eax,%eax
80105426:	75 39                	jne    80105461 <memset+0x50>
    c &= 0xFF;
80105428:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010542f:	8b 45 10             	mov    0x10(%ebp),%eax
80105432:	c1 e8 02             	shr    $0x2,%eax
80105435:	89 c1                	mov    %eax,%ecx
80105437:	8b 45 0c             	mov    0xc(%ebp),%eax
8010543a:	c1 e0 18             	shl    $0x18,%eax
8010543d:	89 c2                	mov    %eax,%edx
8010543f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105442:	c1 e0 10             	shl    $0x10,%eax
80105445:	09 c2                	or     %eax,%edx
80105447:	8b 45 0c             	mov    0xc(%ebp),%eax
8010544a:	c1 e0 08             	shl    $0x8,%eax
8010544d:	09 d0                	or     %edx,%eax
8010544f:	0b 45 0c             	or     0xc(%ebp),%eax
80105452:	51                   	push   %ecx
80105453:	50                   	push   %eax
80105454:	ff 75 08             	pushl  0x8(%ebp)
80105457:	e8 8f ff ff ff       	call   801053eb <stosl>
8010545c:	83 c4 0c             	add    $0xc,%esp
8010545f:	eb 12                	jmp    80105473 <memset+0x62>
  } else
    stosb(dst, c, n);
80105461:	8b 45 10             	mov    0x10(%ebp),%eax
80105464:	50                   	push   %eax
80105465:	ff 75 0c             	pushl  0xc(%ebp)
80105468:	ff 75 08             	pushl  0x8(%ebp)
8010546b:	e8 55 ff ff ff       	call   801053c5 <stosb>
80105470:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105473:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105476:	c9                   	leave  
80105477:	c3                   	ret    

80105478 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105478:	55                   	push   %ebp
80105479:	89 e5                	mov    %esp,%ebp
8010547b:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010547e:	8b 45 08             	mov    0x8(%ebp),%eax
80105481:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105484:	8b 45 0c             	mov    0xc(%ebp),%eax
80105487:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010548a:	eb 30                	jmp    801054bc <memcmp+0x44>
    if(*s1 != *s2)
8010548c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010548f:	0f b6 10             	movzbl (%eax),%edx
80105492:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105495:	0f b6 00             	movzbl (%eax),%eax
80105498:	38 c2                	cmp    %al,%dl
8010549a:	74 18                	je     801054b4 <memcmp+0x3c>
      return *s1 - *s2;
8010549c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010549f:	0f b6 00             	movzbl (%eax),%eax
801054a2:	0f b6 d0             	movzbl %al,%edx
801054a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054a8:	0f b6 00             	movzbl (%eax),%eax
801054ab:	0f b6 c0             	movzbl %al,%eax
801054ae:	29 c2                	sub    %eax,%edx
801054b0:	89 d0                	mov    %edx,%eax
801054b2:	eb 1a                	jmp    801054ce <memcmp+0x56>
    s1++, s2++;
801054b4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801054b8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
801054bc:	8b 45 10             	mov    0x10(%ebp),%eax
801054bf:	8d 50 ff             	lea    -0x1(%eax),%edx
801054c2:	89 55 10             	mov    %edx,0x10(%ebp)
801054c5:	85 c0                	test   %eax,%eax
801054c7:	75 c3                	jne    8010548c <memcmp+0x14>
  }

  return 0;
801054c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054ce:	c9                   	leave  
801054cf:	c3                   	ret    

801054d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801054d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801054d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801054dc:	8b 45 08             	mov    0x8(%ebp),%eax
801054df:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801054e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054e5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801054e8:	73 54                	jae    8010553e <memmove+0x6e>
801054ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054ed:	8b 45 10             	mov    0x10(%ebp),%eax
801054f0:	01 d0                	add    %edx,%eax
801054f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801054f5:	76 47                	jbe    8010553e <memmove+0x6e>
    s += n;
801054f7:	8b 45 10             	mov    0x10(%ebp),%eax
801054fa:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801054fd:	8b 45 10             	mov    0x10(%ebp),%eax
80105500:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105503:	eb 13                	jmp    80105518 <memmove+0x48>
      *--d = *--s;
80105505:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105509:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010550d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105510:	0f b6 10             	movzbl (%eax),%edx
80105513:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105516:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105518:	8b 45 10             	mov    0x10(%ebp),%eax
8010551b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010551e:	89 55 10             	mov    %edx,0x10(%ebp)
80105521:	85 c0                	test   %eax,%eax
80105523:	75 e0                	jne    80105505 <memmove+0x35>
  if(s < d && s + n > d){
80105525:	eb 24                	jmp    8010554b <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
80105527:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010552a:	8d 50 01             	lea    0x1(%eax),%edx
8010552d:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105530:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105533:	8d 4a 01             	lea    0x1(%edx),%ecx
80105536:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105539:	0f b6 12             	movzbl (%edx),%edx
8010553c:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010553e:	8b 45 10             	mov    0x10(%ebp),%eax
80105541:	8d 50 ff             	lea    -0x1(%eax),%edx
80105544:	89 55 10             	mov    %edx,0x10(%ebp)
80105547:	85 c0                	test   %eax,%eax
80105549:	75 dc                	jne    80105527 <memmove+0x57>

  return dst;
8010554b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010554e:	c9                   	leave  
8010554f:	c3                   	ret    

80105550 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105553:	ff 75 10             	pushl  0x10(%ebp)
80105556:	ff 75 0c             	pushl  0xc(%ebp)
80105559:	ff 75 08             	pushl  0x8(%ebp)
8010555c:	e8 6f ff ff ff       	call   801054d0 <memmove>
80105561:	83 c4 0c             	add    $0xc,%esp
}
80105564:	c9                   	leave  
80105565:	c3                   	ret    

80105566 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105566:	55                   	push   %ebp
80105567:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105569:	eb 0c                	jmp    80105577 <strncmp+0x11>
    n--, p++, q++;
8010556b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010556f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105573:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80105577:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010557b:	74 1a                	je     80105597 <strncmp+0x31>
8010557d:	8b 45 08             	mov    0x8(%ebp),%eax
80105580:	0f b6 00             	movzbl (%eax),%eax
80105583:	84 c0                	test   %al,%al
80105585:	74 10                	je     80105597 <strncmp+0x31>
80105587:	8b 45 08             	mov    0x8(%ebp),%eax
8010558a:	0f b6 10             	movzbl (%eax),%edx
8010558d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105590:	0f b6 00             	movzbl (%eax),%eax
80105593:	38 c2                	cmp    %al,%dl
80105595:	74 d4                	je     8010556b <strncmp+0x5>
  if(n == 0)
80105597:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010559b:	75 07                	jne    801055a4 <strncmp+0x3e>
    return 0;
8010559d:	b8 00 00 00 00       	mov    $0x0,%eax
801055a2:	eb 16                	jmp    801055ba <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801055a4:	8b 45 08             	mov    0x8(%ebp),%eax
801055a7:	0f b6 00             	movzbl (%eax),%eax
801055aa:	0f b6 d0             	movzbl %al,%edx
801055ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801055b0:	0f b6 00             	movzbl (%eax),%eax
801055b3:	0f b6 c0             	movzbl %al,%eax
801055b6:	29 c2                	sub    %eax,%edx
801055b8:	89 d0                	mov    %edx,%eax
}
801055ba:	5d                   	pop    %ebp
801055bb:	c3                   	ret    

801055bc <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801055bc:	55                   	push   %ebp
801055bd:	89 e5                	mov    %esp,%ebp
801055bf:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801055c2:	8b 45 08             	mov    0x8(%ebp),%eax
801055c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801055c8:	90                   	nop
801055c9:	8b 45 10             	mov    0x10(%ebp),%eax
801055cc:	8d 50 ff             	lea    -0x1(%eax),%edx
801055cf:	89 55 10             	mov    %edx,0x10(%ebp)
801055d2:	85 c0                	test   %eax,%eax
801055d4:	7e 2c                	jle    80105602 <strncpy+0x46>
801055d6:	8b 45 08             	mov    0x8(%ebp),%eax
801055d9:	8d 50 01             	lea    0x1(%eax),%edx
801055dc:	89 55 08             	mov    %edx,0x8(%ebp)
801055df:	8b 55 0c             	mov    0xc(%ebp),%edx
801055e2:	8d 4a 01             	lea    0x1(%edx),%ecx
801055e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801055e8:	0f b6 12             	movzbl (%edx),%edx
801055eb:	88 10                	mov    %dl,(%eax)
801055ed:	0f b6 00             	movzbl (%eax),%eax
801055f0:	84 c0                	test   %al,%al
801055f2:	75 d5                	jne    801055c9 <strncpy+0xd>
    ;
  while(n-- > 0)
801055f4:	eb 0c                	jmp    80105602 <strncpy+0x46>
    *s++ = 0;
801055f6:	8b 45 08             	mov    0x8(%ebp),%eax
801055f9:	8d 50 01             	lea    0x1(%eax),%edx
801055fc:	89 55 08             	mov    %edx,0x8(%ebp)
801055ff:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80105602:	8b 45 10             	mov    0x10(%ebp),%eax
80105605:	8d 50 ff             	lea    -0x1(%eax),%edx
80105608:	89 55 10             	mov    %edx,0x10(%ebp)
8010560b:	85 c0                	test   %eax,%eax
8010560d:	7f e7                	jg     801055f6 <strncpy+0x3a>
  return os;
8010560f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105612:	c9                   	leave  
80105613:	c3                   	ret    

80105614 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105614:	55                   	push   %ebp
80105615:	89 e5                	mov    %esp,%ebp
80105617:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010561a:	8b 45 08             	mov    0x8(%ebp),%eax
8010561d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105620:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105624:	7f 05                	jg     8010562b <safestrcpy+0x17>
    return os;
80105626:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105629:	eb 31                	jmp    8010565c <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010562b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010562f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105633:	7e 1e                	jle    80105653 <safestrcpy+0x3f>
80105635:	8b 45 08             	mov    0x8(%ebp),%eax
80105638:	8d 50 01             	lea    0x1(%eax),%edx
8010563b:	89 55 08             	mov    %edx,0x8(%ebp)
8010563e:	8b 55 0c             	mov    0xc(%ebp),%edx
80105641:	8d 4a 01             	lea    0x1(%edx),%ecx
80105644:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105647:	0f b6 12             	movzbl (%edx),%edx
8010564a:	88 10                	mov    %dl,(%eax)
8010564c:	0f b6 00             	movzbl (%eax),%eax
8010564f:	84 c0                	test   %al,%al
80105651:	75 d8                	jne    8010562b <safestrcpy+0x17>
    ;
  *s = 0;
80105653:	8b 45 08             	mov    0x8(%ebp),%eax
80105656:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105659:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010565c:	c9                   	leave  
8010565d:	c3                   	ret    

8010565e <strlen>:

int
strlen(const char *s)
{
8010565e:	55                   	push   %ebp
8010565f:	89 e5                	mov    %esp,%ebp
80105661:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105664:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010566b:	eb 04                	jmp    80105671 <strlen+0x13>
8010566d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105671:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105674:	8b 45 08             	mov    0x8(%ebp),%eax
80105677:	01 d0                	add    %edx,%eax
80105679:	0f b6 00             	movzbl (%eax),%eax
8010567c:	84 c0                	test   %al,%al
8010567e:	75 ed                	jne    8010566d <strlen+0xf>
    ;
  return n;
80105680:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105683:	c9                   	leave  
80105684:	c3                   	ret    

80105685 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105685:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105689:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010568d:	55                   	push   %ebp
  pushl %ebx
8010568e:	53                   	push   %ebx
  pushl %esi
8010568f:	56                   	push   %esi
  pushl %edi
80105690:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105691:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105693:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105695:	5f                   	pop    %edi
  popl %esi
80105696:	5e                   	pop    %esi
  popl %ebx
80105697:	5b                   	pop    %ebx
  popl %ebp
80105698:	5d                   	pop    %ebp
  ret
80105699:	c3                   	ret    

8010569a <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010569a:	55                   	push   %ebp
8010569b:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010569d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056a3:	8b 00                	mov    (%eax),%eax
801056a5:	3b 45 08             	cmp    0x8(%ebp),%eax
801056a8:	76 12                	jbe    801056bc <fetchint+0x22>
801056aa:	8b 45 08             	mov    0x8(%ebp),%eax
801056ad:	8d 50 04             	lea    0x4(%eax),%edx
801056b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056b6:	8b 00                	mov    (%eax),%eax
801056b8:	39 c2                	cmp    %eax,%edx
801056ba:	76 07                	jbe    801056c3 <fetchint+0x29>
    return -1;
801056bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056c1:	eb 0f                	jmp    801056d2 <fetchint+0x38>
  *ip = *(int*)(addr);
801056c3:	8b 45 08             	mov    0x8(%ebp),%eax
801056c6:	8b 10                	mov    (%eax),%edx
801056c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801056cb:	89 10                	mov    %edx,(%eax)
  return 0;
801056cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056d2:	5d                   	pop    %ebp
801056d3:	c3                   	ret    

801056d4 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801056da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056e0:	8b 00                	mov    (%eax),%eax
801056e2:	3b 45 08             	cmp    0x8(%ebp),%eax
801056e5:	77 07                	ja     801056ee <fetchstr+0x1a>
    return -1;
801056e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ec:	eb 46                	jmp    80105734 <fetchstr+0x60>
  *pp = (char*)addr;
801056ee:	8b 55 08             	mov    0x8(%ebp),%edx
801056f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801056f4:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801056f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056fc:	8b 00                	mov    (%eax),%eax
801056fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105701:	8b 45 0c             	mov    0xc(%ebp),%eax
80105704:	8b 00                	mov    (%eax),%eax
80105706:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105709:	eb 1c                	jmp    80105727 <fetchstr+0x53>
    if(*s == 0)
8010570b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010570e:	0f b6 00             	movzbl (%eax),%eax
80105711:	84 c0                	test   %al,%al
80105713:	75 0e                	jne    80105723 <fetchstr+0x4f>
      return s - *pp;
80105715:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105718:	8b 45 0c             	mov    0xc(%ebp),%eax
8010571b:	8b 00                	mov    (%eax),%eax
8010571d:	29 c2                	sub    %eax,%edx
8010571f:	89 d0                	mov    %edx,%eax
80105721:	eb 11                	jmp    80105734 <fetchstr+0x60>
  for(s = *pp; s < ep; s++)
80105723:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105727:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010572a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010572d:	72 dc                	jb     8010570b <fetchstr+0x37>
  return -1;
8010572f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105734:	c9                   	leave  
80105735:	c3                   	ret    

80105736 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105736:	55                   	push   %ebp
80105737:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105739:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010573f:	8b 40 18             	mov    0x18(%eax),%eax
80105742:	8b 40 44             	mov    0x44(%eax),%eax
80105745:	8b 55 08             	mov    0x8(%ebp),%edx
80105748:	c1 e2 02             	shl    $0x2,%edx
8010574b:	01 d0                	add    %edx,%eax
8010574d:	83 c0 04             	add    $0x4,%eax
80105750:	ff 75 0c             	pushl  0xc(%ebp)
80105753:	50                   	push   %eax
80105754:	e8 41 ff ff ff       	call   8010569a <fetchint>
80105759:	83 c4 08             	add    $0x8,%esp
}
8010575c:	c9                   	leave  
8010575d:	c3                   	ret    

8010575e <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010575e:	55                   	push   %ebp
8010575f:	89 e5                	mov    %esp,%ebp
80105761:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105764:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105767:	50                   	push   %eax
80105768:	ff 75 08             	pushl  0x8(%ebp)
8010576b:	e8 c6 ff ff ff       	call   80105736 <argint>
80105770:	83 c4 08             	add    $0x8,%esp
80105773:	85 c0                	test   %eax,%eax
80105775:	79 07                	jns    8010577e <argptr+0x20>
    return -1;
80105777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577c:	eb 3b                	jmp    801057b9 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010577e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105784:	8b 00                	mov    (%eax),%eax
80105786:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105789:	39 d0                	cmp    %edx,%eax
8010578b:	76 16                	jbe    801057a3 <argptr+0x45>
8010578d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105790:	89 c2                	mov    %eax,%edx
80105792:	8b 45 10             	mov    0x10(%ebp),%eax
80105795:	01 c2                	add    %eax,%edx
80105797:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010579d:	8b 00                	mov    (%eax),%eax
8010579f:	39 c2                	cmp    %eax,%edx
801057a1:	76 07                	jbe    801057aa <argptr+0x4c>
    return -1;
801057a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a8:	eb 0f                	jmp    801057b9 <argptr+0x5b>
  *pp = (char*)i;
801057aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057ad:	89 c2                	mov    %eax,%edx
801057af:	8b 45 0c             	mov    0xc(%ebp),%eax
801057b2:	89 10                	mov    %edx,(%eax)
  return 0;
801057b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057b9:	c9                   	leave  
801057ba:	c3                   	ret    

801057bb <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801057bb:	55                   	push   %ebp
801057bc:	89 e5                	mov    %esp,%ebp
801057be:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801057c1:	8d 45 fc             	lea    -0x4(%ebp),%eax
801057c4:	50                   	push   %eax
801057c5:	ff 75 08             	pushl  0x8(%ebp)
801057c8:	e8 69 ff ff ff       	call   80105736 <argint>
801057cd:	83 c4 08             	add    $0x8,%esp
801057d0:	85 c0                	test   %eax,%eax
801057d2:	79 07                	jns    801057db <argstr+0x20>
    return -1;
801057d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d9:	eb 0f                	jmp    801057ea <argstr+0x2f>
  return fetchstr(addr, pp);
801057db:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057de:	ff 75 0c             	pushl  0xc(%ebp)
801057e1:	50                   	push   %eax
801057e2:	e8 ed fe ff ff       	call   801056d4 <fetchstr>
801057e7:	83 c4 08             	add    $0x8,%esp
}
801057ea:	c9                   	leave  
801057eb:	c3                   	ret    

801057ec <syscall>:
[SYS_settickets] sys_settickets,
};

void
syscall(void)
{
801057ec:	55                   	push   %ebp
801057ed:	89 e5                	mov    %esp,%ebp
801057ef:	53                   	push   %ebx
801057f0:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801057f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057f9:	8b 40 18             	mov    0x18(%eax),%eax
801057fc:	8b 40 1c             	mov    0x1c(%eax),%eax
801057ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105806:	7e 30                	jle    80105838 <syscall+0x4c>
80105808:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010580b:	83 f8 17             	cmp    $0x17,%eax
8010580e:	77 28                	ja     80105838 <syscall+0x4c>
80105810:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105813:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010581a:	85 c0                	test   %eax,%eax
8010581c:	74 1a                	je     80105838 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
8010581e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105824:	8b 58 18             	mov    0x18(%eax),%ebx
80105827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010582a:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105831:	ff d0                	call   *%eax
80105833:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105836:	eb 34                	jmp    8010586c <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105838:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010583e:	8d 50 6c             	lea    0x6c(%eax),%edx
80105841:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
80105847:	8b 40 10             	mov    0x10(%eax),%eax
8010584a:	ff 75 f4             	pushl  -0xc(%ebp)
8010584d:	52                   	push   %edx
8010584e:	50                   	push   %eax
8010584f:	68 d3 8d 10 80       	push   $0x80108dd3
80105854:	e8 c1 ab ff ff       	call   8010041a <cprintf>
80105859:	83 c4 10             	add    $0x10,%esp
    proc->tf->eax = -1;
8010585c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105862:	8b 40 18             	mov    0x18(%eax),%eax
80105865:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010586c:	90                   	nop
8010586d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105870:	c9                   	leave  
80105871:	c3                   	ret    

80105872 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105872:	55                   	push   %ebp
80105873:	89 e5                	mov    %esp,%ebp
80105875:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105878:	83 ec 08             	sub    $0x8,%esp
8010587b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010587e:	50                   	push   %eax
8010587f:	ff 75 08             	pushl  0x8(%ebp)
80105882:	e8 af fe ff ff       	call   80105736 <argint>
80105887:	83 c4 10             	add    $0x10,%esp
8010588a:	85 c0                	test   %eax,%eax
8010588c:	79 07                	jns    80105895 <argfd+0x23>
    return -1;
8010588e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105893:	eb 50                	jmp    801058e5 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105895:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105898:	85 c0                	test   %eax,%eax
8010589a:	78 21                	js     801058bd <argfd+0x4b>
8010589c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010589f:	83 f8 0f             	cmp    $0xf,%eax
801058a2:	7f 19                	jg     801058bd <argfd+0x4b>
801058a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058ad:	83 c2 08             	add    $0x8,%edx
801058b0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801058b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058bb:	75 07                	jne    801058c4 <argfd+0x52>
    return -1;
801058bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c2:	eb 21                	jmp    801058e5 <argfd+0x73>
  if(pfd)
801058c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801058c8:	74 08                	je     801058d2 <argfd+0x60>
    *pfd = fd;
801058ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801058d0:	89 10                	mov    %edx,(%eax)
  if(pf)
801058d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058d6:	74 08                	je     801058e0 <argfd+0x6e>
    *pf = f;
801058d8:	8b 45 10             	mov    0x10(%ebp),%eax
801058db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058de:	89 10                	mov    %edx,(%eax)
  return 0;
801058e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    

801058e7 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801058e7:	55                   	push   %ebp
801058e8:	89 e5                	mov    %esp,%ebp
801058ea:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801058ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801058f4:	eb 30                	jmp    80105926 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801058f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058ff:	83 c2 08             	add    $0x8,%edx
80105902:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105906:	85 c0                	test   %eax,%eax
80105908:	75 18                	jne    80105922 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010590a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105910:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105913:	8d 4a 08             	lea    0x8(%edx),%ecx
80105916:	8b 55 08             	mov    0x8(%ebp),%edx
80105919:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010591d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105920:	eb 0f                	jmp    80105931 <fdalloc+0x4a>
  for(fd = 0; fd < NOFILE; fd++){
80105922:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105926:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010592a:	7e ca                	jle    801058f6 <fdalloc+0xf>
    }
  }
  return -1;
8010592c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105931:	c9                   	leave  
80105932:	c3                   	ret    

80105933 <sys_dup>:

int
sys_dup(void)
{
80105933:	55                   	push   %ebp
80105934:	89 e5                	mov    %esp,%ebp
80105936:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105939:	83 ec 04             	sub    $0x4,%esp
8010593c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010593f:	50                   	push   %eax
80105940:	6a 00                	push   $0x0
80105942:	6a 00                	push   $0x0
80105944:	e8 29 ff ff ff       	call   80105872 <argfd>
80105949:	83 c4 10             	add    $0x10,%esp
8010594c:	85 c0                	test   %eax,%eax
8010594e:	79 07                	jns    80105957 <sys_dup+0x24>
    return -1;
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105955:	eb 31                	jmp    80105988 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105957:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595a:	83 ec 0c             	sub    $0xc,%esp
8010595d:	50                   	push   %eax
8010595e:	e8 84 ff ff ff       	call   801058e7 <fdalloc>
80105963:	83 c4 10             	add    $0x10,%esp
80105966:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105969:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010596d:	79 07                	jns    80105976 <sys_dup+0x43>
    return -1;
8010596f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105974:	eb 12                	jmp    80105988 <sys_dup+0x55>
  filedup(f);
80105976:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105979:	83 ec 0c             	sub    $0xc,%esp
8010597c:	50                   	push   %eax
8010597d:	e8 fa b6 ff ff       	call   8010107c <filedup>
80105982:	83 c4 10             	add    $0x10,%esp
  return fd;
80105985:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105988:	c9                   	leave  
80105989:	c3                   	ret    

8010598a <sys_read>:

int
sys_read(void)
{
8010598a:	55                   	push   %ebp
8010598b:	89 e5                	mov    %esp,%ebp
8010598d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105990:	83 ec 04             	sub    $0x4,%esp
80105993:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105996:	50                   	push   %eax
80105997:	6a 00                	push   $0x0
80105999:	6a 00                	push   $0x0
8010599b:	e8 d2 fe ff ff       	call   80105872 <argfd>
801059a0:	83 c4 10             	add    $0x10,%esp
801059a3:	85 c0                	test   %eax,%eax
801059a5:	78 2e                	js     801059d5 <sys_read+0x4b>
801059a7:	83 ec 08             	sub    $0x8,%esp
801059aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ad:	50                   	push   %eax
801059ae:	6a 02                	push   $0x2
801059b0:	e8 81 fd ff ff       	call   80105736 <argint>
801059b5:	83 c4 10             	add    $0x10,%esp
801059b8:	85 c0                	test   %eax,%eax
801059ba:	78 19                	js     801059d5 <sys_read+0x4b>
801059bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059bf:	83 ec 04             	sub    $0x4,%esp
801059c2:	50                   	push   %eax
801059c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059c6:	50                   	push   %eax
801059c7:	6a 01                	push   $0x1
801059c9:	e8 90 fd ff ff       	call   8010575e <argptr>
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	85 c0                	test   %eax,%eax
801059d3:	79 07                	jns    801059dc <sys_read+0x52>
    return -1;
801059d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059da:	eb 17                	jmp    801059f3 <sys_read+0x69>
  return fileread(f, p, n);
801059dc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801059df:	8b 55 ec             	mov    -0x14(%ebp),%edx
801059e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e5:	83 ec 04             	sub    $0x4,%esp
801059e8:	51                   	push   %ecx
801059e9:	52                   	push   %edx
801059ea:	50                   	push   %eax
801059eb:	e8 1c b8 ff ff       	call   8010120c <fileread>
801059f0:	83 c4 10             	add    $0x10,%esp
}
801059f3:	c9                   	leave  
801059f4:	c3                   	ret    

801059f5 <sys_write>:

int
sys_write(void)
{
801059f5:	55                   	push   %ebp
801059f6:	89 e5                	mov    %esp,%ebp
801059f8:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059fb:	83 ec 04             	sub    $0x4,%esp
801059fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a01:	50                   	push   %eax
80105a02:	6a 00                	push   $0x0
80105a04:	6a 00                	push   $0x0
80105a06:	e8 67 fe ff ff       	call   80105872 <argfd>
80105a0b:	83 c4 10             	add    $0x10,%esp
80105a0e:	85 c0                	test   %eax,%eax
80105a10:	78 2e                	js     80105a40 <sys_write+0x4b>
80105a12:	83 ec 08             	sub    $0x8,%esp
80105a15:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a18:	50                   	push   %eax
80105a19:	6a 02                	push   $0x2
80105a1b:	e8 16 fd ff ff       	call   80105736 <argint>
80105a20:	83 c4 10             	add    $0x10,%esp
80105a23:	85 c0                	test   %eax,%eax
80105a25:	78 19                	js     80105a40 <sys_write+0x4b>
80105a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a2a:	83 ec 04             	sub    $0x4,%esp
80105a2d:	50                   	push   %eax
80105a2e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a31:	50                   	push   %eax
80105a32:	6a 01                	push   $0x1
80105a34:	e8 25 fd ff ff       	call   8010575e <argptr>
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	85 c0                	test   %eax,%eax
80105a3e:	79 07                	jns    80105a47 <sys_write+0x52>
    return -1;
80105a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a45:	eb 17                	jmp    80105a5e <sys_write+0x69>
  return filewrite(f, p, n);
80105a47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105a4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a50:	83 ec 04             	sub    $0x4,%esp
80105a53:	51                   	push   %ecx
80105a54:	52                   	push   %edx
80105a55:	50                   	push   %eax
80105a56:	e8 69 b8 ff ff       	call   801012c4 <filewrite>
80105a5b:	83 c4 10             	add    $0x10,%esp
}
80105a5e:	c9                   	leave  
80105a5f:	c3                   	ret    

80105a60 <sys_close>:

int
sys_close(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105a66:	83 ec 04             	sub    $0x4,%esp
80105a69:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a6c:	50                   	push   %eax
80105a6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a70:	50                   	push   %eax
80105a71:	6a 00                	push   $0x0
80105a73:	e8 fa fd ff ff       	call   80105872 <argfd>
80105a78:	83 c4 10             	add    $0x10,%esp
80105a7b:	85 c0                	test   %eax,%eax
80105a7d:	79 07                	jns    80105a86 <sys_close+0x26>
    return -1;
80105a7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a84:	eb 28                	jmp    80105aae <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105a86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a8f:	83 c2 08             	add    $0x8,%edx
80105a92:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105a99:	00 
  fileclose(f);
80105a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a9d:	83 ec 0c             	sub    $0xc,%esp
80105aa0:	50                   	push   %eax
80105aa1:	e8 27 b6 ff ff       	call   801010cd <fileclose>
80105aa6:	83 c4 10             	add    $0x10,%esp
  return 0;
80105aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105aae:	c9                   	leave  
80105aaf:	c3                   	ret    

80105ab0 <sys_fstat>:

int
sys_fstat(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105ab6:	83 ec 04             	sub    $0x4,%esp
80105ab9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105abc:	50                   	push   %eax
80105abd:	6a 00                	push   $0x0
80105abf:	6a 00                	push   $0x0
80105ac1:	e8 ac fd ff ff       	call   80105872 <argfd>
80105ac6:	83 c4 10             	add    $0x10,%esp
80105ac9:	85 c0                	test   %eax,%eax
80105acb:	78 17                	js     80105ae4 <sys_fstat+0x34>
80105acd:	83 ec 04             	sub    $0x4,%esp
80105ad0:	6a 14                	push   $0x14
80105ad2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad5:	50                   	push   %eax
80105ad6:	6a 01                	push   $0x1
80105ad8:	e8 81 fc ff ff       	call   8010575e <argptr>
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	85 c0                	test   %eax,%eax
80105ae2:	79 07                	jns    80105aeb <sys_fstat+0x3b>
    return -1;
80105ae4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae9:	eb 13                	jmp    80105afe <sys_fstat+0x4e>
  return filestat(f, st);
80105aeb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af1:	83 ec 08             	sub    $0x8,%esp
80105af4:	52                   	push   %edx
80105af5:	50                   	push   %eax
80105af6:	e8 ba b6 ff ff       	call   801011b5 <filestat>
80105afb:	83 c4 10             	add    $0x10,%esp
}
80105afe:	c9                   	leave  
80105aff:	c3                   	ret    

80105b00 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b06:	83 ec 08             	sub    $0x8,%esp
80105b09:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105b0c:	50                   	push   %eax
80105b0d:	6a 00                	push   $0x0
80105b0f:	e8 a7 fc ff ff       	call   801057bb <argstr>
80105b14:	83 c4 10             	add    $0x10,%esp
80105b17:	85 c0                	test   %eax,%eax
80105b19:	78 15                	js     80105b30 <sys_link+0x30>
80105b1b:	83 ec 08             	sub    $0x8,%esp
80105b1e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105b21:	50                   	push   %eax
80105b22:	6a 01                	push   $0x1
80105b24:	e8 92 fc ff ff       	call   801057bb <argstr>
80105b29:	83 c4 10             	add    $0x10,%esp
80105b2c:	85 c0                	test   %eax,%eax
80105b2e:	79 0a                	jns    80105b3a <sys_link+0x3a>
    return -1;
80105b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b35:	e9 68 01 00 00       	jmp    80105ca2 <sys_link+0x1a2>

  begin_op();
80105b3a:	e8 dd da ff ff       	call   8010361c <begin_op>
  if((ip = namei(old)) == 0){
80105b3f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105b42:	83 ec 0c             	sub    $0xc,%esp
80105b45:	50                   	push   %eax
80105b46:	e8 59 ca ff ff       	call   801025a4 <namei>
80105b4b:	83 c4 10             	add    $0x10,%esp
80105b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b55:	75 0f                	jne    80105b66 <sys_link+0x66>
    end_op();
80105b57:	e8 4c db ff ff       	call   801036a8 <end_op>
    return -1;
80105b5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b61:	e9 3c 01 00 00       	jmp    80105ca2 <sys_link+0x1a2>
  }

  ilock(ip);
80105b66:	83 ec 0c             	sub    $0xc,%esp
80105b69:	ff 75 f4             	pushl  -0xc(%ebp)
80105b6c:	e8 75 be ff ff       	call   801019e6 <ilock>
80105b71:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b77:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b7b:	66 83 f8 01          	cmp    $0x1,%ax
80105b7f:	75 1d                	jne    80105b9e <sys_link+0x9e>
    iunlockput(ip);
80105b81:	83 ec 0c             	sub    $0xc,%esp
80105b84:	ff 75 f4             	pushl  -0xc(%ebp)
80105b87:	e8 1a c1 ff ff       	call   80101ca6 <iunlockput>
80105b8c:	83 c4 10             	add    $0x10,%esp
    end_op();
80105b8f:	e8 14 db ff ff       	call   801036a8 <end_op>
    return -1;
80105b94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b99:	e9 04 01 00 00       	jmp    80105ca2 <sys_link+0x1a2>
  }

  ip->nlink++;
80105b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ba5:	83 c0 01             	add    $0x1,%eax
80105ba8:	89 c2                	mov    %eax,%edx
80105baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bad:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105bb1:	83 ec 0c             	sub    $0xc,%esp
80105bb4:	ff 75 f4             	pushl  -0xc(%ebp)
80105bb7:	e8 50 bc ff ff       	call   8010180c <iupdate>
80105bbc:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105bbf:	83 ec 0c             	sub    $0xc,%esp
80105bc2:	ff 75 f4             	pushl  -0xc(%ebp)
80105bc5:	e8 7a bf ff ff       	call   80101b44 <iunlock>
80105bca:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105bcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bd0:	83 ec 08             	sub    $0x8,%esp
80105bd3:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105bd6:	52                   	push   %edx
80105bd7:	50                   	push   %eax
80105bd8:	e8 e3 c9 ff ff       	call   801025c0 <nameiparent>
80105bdd:	83 c4 10             	add    $0x10,%esp
80105be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105be3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105be7:	74 71                	je     80105c5a <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105be9:	83 ec 0c             	sub    $0xc,%esp
80105bec:	ff 75 f0             	pushl  -0x10(%ebp)
80105bef:	e8 f2 bd ff ff       	call   801019e6 <ilock>
80105bf4:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bfa:	8b 10                	mov    (%eax),%edx
80105bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bff:	8b 00                	mov    (%eax),%eax
80105c01:	39 c2                	cmp    %eax,%edx
80105c03:	75 1d                	jne    80105c22 <sys_link+0x122>
80105c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c08:	8b 40 04             	mov    0x4(%eax),%eax
80105c0b:	83 ec 04             	sub    $0x4,%esp
80105c0e:	50                   	push   %eax
80105c0f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105c12:	50                   	push   %eax
80105c13:	ff 75 f0             	pushl  -0x10(%ebp)
80105c16:	e8 ed c6 ff ff       	call   80102308 <dirlink>
80105c1b:	83 c4 10             	add    $0x10,%esp
80105c1e:	85 c0                	test   %eax,%eax
80105c20:	79 10                	jns    80105c32 <sys_link+0x132>
    iunlockput(dp);
80105c22:	83 ec 0c             	sub    $0xc,%esp
80105c25:	ff 75 f0             	pushl  -0x10(%ebp)
80105c28:	e8 79 c0 ff ff       	call   80101ca6 <iunlockput>
80105c2d:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105c30:	eb 29                	jmp    80105c5b <sys_link+0x15b>
  }
  iunlockput(dp);
80105c32:	83 ec 0c             	sub    $0xc,%esp
80105c35:	ff 75 f0             	pushl  -0x10(%ebp)
80105c38:	e8 69 c0 ff ff       	call   80101ca6 <iunlockput>
80105c3d:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	ff 75 f4             	pushl  -0xc(%ebp)
80105c46:	e8 6b bf ff ff       	call   80101bb6 <iput>
80105c4b:	83 c4 10             	add    $0x10,%esp

  end_op();
80105c4e:	e8 55 da ff ff       	call   801036a8 <end_op>

  return 0;
80105c53:	b8 00 00 00 00       	mov    $0x0,%eax
80105c58:	eb 48                	jmp    80105ca2 <sys_link+0x1a2>
    goto bad;
80105c5a:	90                   	nop

bad:
  ilock(ip);
80105c5b:	83 ec 0c             	sub    $0xc,%esp
80105c5e:	ff 75 f4             	pushl  -0xc(%ebp)
80105c61:	e8 80 bd ff ff       	call   801019e6 <ilock>
80105c66:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c70:	83 e8 01             	sub    $0x1,%eax
80105c73:	89 c2                	mov    %eax,%edx
80105c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c78:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c7c:	83 ec 0c             	sub    $0xc,%esp
80105c7f:	ff 75 f4             	pushl  -0xc(%ebp)
80105c82:	e8 85 bb ff ff       	call   8010180c <iupdate>
80105c87:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105c8a:	83 ec 0c             	sub    $0xc,%esp
80105c8d:	ff 75 f4             	pushl  -0xc(%ebp)
80105c90:	e8 11 c0 ff ff       	call   80101ca6 <iunlockput>
80105c95:	83 c4 10             	add    $0x10,%esp
  end_op();
80105c98:	e8 0b da ff ff       	call   801036a8 <end_op>
  return -1;
80105c9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ca2:	c9                   	leave  
80105ca3:	c3                   	ret    

80105ca4 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105ca4:	55                   	push   %ebp
80105ca5:	89 e5                	mov    %esp,%ebp
80105ca7:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105caa:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105cb1:	eb 40                	jmp    80105cf3 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb6:	6a 10                	push   $0x10
80105cb8:	50                   	push   %eax
80105cb9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cbc:	50                   	push   %eax
80105cbd:	ff 75 08             	pushl  0x8(%ebp)
80105cc0:	e8 8f c2 ff ff       	call   80101f54 <readi>
80105cc5:	83 c4 10             	add    $0x10,%esp
80105cc8:	83 f8 10             	cmp    $0x10,%eax
80105ccb:	74 0d                	je     80105cda <isdirempty+0x36>
      panic("isdirempty: readi");
80105ccd:	83 ec 0c             	sub    $0xc,%esp
80105cd0:	68 ef 8d 10 80       	push   $0x80108def
80105cd5:	e8 08 a9 ff ff       	call   801005e2 <panic>
    if(de.inum != 0)
80105cda:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105cde:	66 85 c0             	test   %ax,%ax
80105ce1:	74 07                	je     80105cea <isdirempty+0x46>
      return 0;
80105ce3:	b8 00 00 00 00       	mov    $0x0,%eax
80105ce8:	eb 1b                	jmp    80105d05 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ced:	83 c0 10             	add    $0x10,%eax
80105cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cf3:	8b 45 08             	mov    0x8(%ebp),%eax
80105cf6:	8b 50 18             	mov    0x18(%eax),%edx
80105cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfc:	39 c2                	cmp    %eax,%edx
80105cfe:	77 b3                	ja     80105cb3 <isdirempty+0xf>
  }
  return 1;
80105d00:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    

80105d07 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105d07:	55                   	push   %ebp
80105d08:	89 e5                	mov    %esp,%ebp
80105d0a:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105d0d:	83 ec 08             	sub    $0x8,%esp
80105d10:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105d13:	50                   	push   %eax
80105d14:	6a 00                	push   $0x0
80105d16:	e8 a0 fa ff ff       	call   801057bb <argstr>
80105d1b:	83 c4 10             	add    $0x10,%esp
80105d1e:	85 c0                	test   %eax,%eax
80105d20:	79 0a                	jns    80105d2c <sys_unlink+0x25>
    return -1;
80105d22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d27:	e9 bc 01 00 00       	jmp    80105ee8 <sys_unlink+0x1e1>

  begin_op();
80105d2c:	e8 eb d8 ff ff       	call   8010361c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105d31:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105d34:	83 ec 08             	sub    $0x8,%esp
80105d37:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105d3a:	52                   	push   %edx
80105d3b:	50                   	push   %eax
80105d3c:	e8 7f c8 ff ff       	call   801025c0 <nameiparent>
80105d41:	83 c4 10             	add    $0x10,%esp
80105d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d4b:	75 0f                	jne    80105d5c <sys_unlink+0x55>
    end_op();
80105d4d:	e8 56 d9 ff ff       	call   801036a8 <end_op>
    return -1;
80105d52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d57:	e9 8c 01 00 00       	jmp    80105ee8 <sys_unlink+0x1e1>
  }

  ilock(dp);
80105d5c:	83 ec 0c             	sub    $0xc,%esp
80105d5f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d62:	e8 7f bc ff ff       	call   801019e6 <ilock>
80105d67:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105d6a:	83 ec 08             	sub    $0x8,%esp
80105d6d:	68 01 8e 10 80       	push   $0x80108e01
80105d72:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d75:	50                   	push   %eax
80105d76:	e8 b8 c4 ff ff       	call   80102233 <namecmp>
80105d7b:	83 c4 10             	add    $0x10,%esp
80105d7e:	85 c0                	test   %eax,%eax
80105d80:	0f 84 4a 01 00 00    	je     80105ed0 <sys_unlink+0x1c9>
80105d86:	83 ec 08             	sub    $0x8,%esp
80105d89:	68 03 8e 10 80       	push   $0x80108e03
80105d8e:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d91:	50                   	push   %eax
80105d92:	e8 9c c4 ff ff       	call   80102233 <namecmp>
80105d97:	83 c4 10             	add    $0x10,%esp
80105d9a:	85 c0                	test   %eax,%eax
80105d9c:	0f 84 2e 01 00 00    	je     80105ed0 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105da2:	83 ec 04             	sub    $0x4,%esp
80105da5:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105da8:	50                   	push   %eax
80105da9:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105dac:	50                   	push   %eax
80105dad:	ff 75 f4             	pushl  -0xc(%ebp)
80105db0:	e8 99 c4 ff ff       	call   8010224e <dirlookup>
80105db5:	83 c4 10             	add    $0x10,%esp
80105db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dbf:	0f 84 0a 01 00 00    	je     80105ecf <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105dc5:	83 ec 0c             	sub    $0xc,%esp
80105dc8:	ff 75 f0             	pushl  -0x10(%ebp)
80105dcb:	e8 16 bc ff ff       	call   801019e6 <ilock>
80105dd0:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd6:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105dda:	66 85 c0             	test   %ax,%ax
80105ddd:	7f 0d                	jg     80105dec <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105ddf:	83 ec 0c             	sub    $0xc,%esp
80105de2:	68 06 8e 10 80       	push   $0x80108e06
80105de7:	e8 f6 a7 ff ff       	call   801005e2 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105def:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105df3:	66 83 f8 01          	cmp    $0x1,%ax
80105df7:	75 25                	jne    80105e1e <sys_unlink+0x117>
80105df9:	83 ec 0c             	sub    $0xc,%esp
80105dfc:	ff 75 f0             	pushl  -0x10(%ebp)
80105dff:	e8 a0 fe ff ff       	call   80105ca4 <isdirempty>
80105e04:	83 c4 10             	add    $0x10,%esp
80105e07:	85 c0                	test   %eax,%eax
80105e09:	75 13                	jne    80105e1e <sys_unlink+0x117>
    iunlockput(ip);
80105e0b:	83 ec 0c             	sub    $0xc,%esp
80105e0e:	ff 75 f0             	pushl  -0x10(%ebp)
80105e11:	e8 90 be ff ff       	call   80101ca6 <iunlockput>
80105e16:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105e19:	e9 b2 00 00 00       	jmp    80105ed0 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105e1e:	83 ec 04             	sub    $0x4,%esp
80105e21:	6a 10                	push   $0x10
80105e23:	6a 00                	push   $0x0
80105e25:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e28:	50                   	push   %eax
80105e29:	e8 e3 f5 ff ff       	call   80105411 <memset>
80105e2e:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e31:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105e34:	6a 10                	push   $0x10
80105e36:	50                   	push   %eax
80105e37:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e3a:	50                   	push   %eax
80105e3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105e3e:	e8 68 c2 ff ff       	call   801020ab <writei>
80105e43:	83 c4 10             	add    $0x10,%esp
80105e46:	83 f8 10             	cmp    $0x10,%eax
80105e49:	74 0d                	je     80105e58 <sys_unlink+0x151>
    panic("unlink: writei");
80105e4b:	83 ec 0c             	sub    $0xc,%esp
80105e4e:	68 18 8e 10 80       	push   $0x80108e18
80105e53:	e8 8a a7 ff ff       	call   801005e2 <panic>
  if(ip->type == T_DIR){
80105e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e5f:	66 83 f8 01          	cmp    $0x1,%ax
80105e63:	75 21                	jne    80105e86 <sys_unlink+0x17f>
    dp->nlink--;
80105e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e68:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e6c:	83 e8 01             	sub    $0x1,%eax
80105e6f:	89 c2                	mov    %eax,%edx
80105e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e74:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105e78:	83 ec 0c             	sub    $0xc,%esp
80105e7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105e7e:	e8 89 b9 ff ff       	call   8010180c <iupdate>
80105e83:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105e86:	83 ec 0c             	sub    $0xc,%esp
80105e89:	ff 75 f4             	pushl  -0xc(%ebp)
80105e8c:	e8 15 be ff ff       	call   80101ca6 <iunlockput>
80105e91:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e97:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e9b:	83 e8 01             	sub    $0x1,%eax
80105e9e:	89 c2                	mov    %eax,%edx
80105ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea3:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ea7:	83 ec 0c             	sub    $0xc,%esp
80105eaa:	ff 75 f0             	pushl  -0x10(%ebp)
80105ead:	e8 5a b9 ff ff       	call   8010180c <iupdate>
80105eb2:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105eb5:	83 ec 0c             	sub    $0xc,%esp
80105eb8:	ff 75 f0             	pushl  -0x10(%ebp)
80105ebb:	e8 e6 bd ff ff       	call   80101ca6 <iunlockput>
80105ec0:	83 c4 10             	add    $0x10,%esp

  end_op();
80105ec3:	e8 e0 d7 ff ff       	call   801036a8 <end_op>

  return 0;
80105ec8:	b8 00 00 00 00       	mov    $0x0,%eax
80105ecd:	eb 19                	jmp    80105ee8 <sys_unlink+0x1e1>
    goto bad;
80105ecf:	90                   	nop

bad:
  iunlockput(dp);
80105ed0:	83 ec 0c             	sub    $0xc,%esp
80105ed3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ed6:	e8 cb bd ff ff       	call   80101ca6 <iunlockput>
80105edb:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ede:	e8 c5 d7 ff ff       	call   801036a8 <end_op>
  return -1;
80105ee3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ee8:	c9                   	leave  
80105ee9:	c3                   	ret    

80105eea <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105eea:	55                   	push   %ebp
80105eeb:	89 e5                	mov    %esp,%ebp
80105eed:	83 ec 38             	sub    $0x38,%esp
80105ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105ef3:	8b 55 10             	mov    0x10(%ebp),%edx
80105ef6:	8b 45 14             	mov    0x14(%ebp),%eax
80105ef9:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105efd:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105f01:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105f05:	83 ec 08             	sub    $0x8,%esp
80105f08:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f0b:	50                   	push   %eax
80105f0c:	ff 75 08             	pushl  0x8(%ebp)
80105f0f:	e8 ac c6 ff ff       	call   801025c0 <nameiparent>
80105f14:	83 c4 10             	add    $0x10,%esp
80105f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f1e:	75 0a                	jne    80105f2a <create+0x40>
    return 0;
80105f20:	b8 00 00 00 00       	mov    $0x0,%eax
80105f25:	e9 90 01 00 00       	jmp    801060ba <create+0x1d0>
  ilock(dp);
80105f2a:	83 ec 0c             	sub    $0xc,%esp
80105f2d:	ff 75 f4             	pushl  -0xc(%ebp)
80105f30:	e8 b1 ba ff ff       	call   801019e6 <ilock>
80105f35:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105f38:	83 ec 04             	sub    $0x4,%esp
80105f3b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f3e:	50                   	push   %eax
80105f3f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f42:	50                   	push   %eax
80105f43:	ff 75 f4             	pushl  -0xc(%ebp)
80105f46:	e8 03 c3 ff ff       	call   8010224e <dirlookup>
80105f4b:	83 c4 10             	add    $0x10,%esp
80105f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f55:	74 50                	je     80105fa7 <create+0xbd>
    iunlockput(dp);
80105f57:	83 ec 0c             	sub    $0xc,%esp
80105f5a:	ff 75 f4             	pushl  -0xc(%ebp)
80105f5d:	e8 44 bd ff ff       	call   80101ca6 <iunlockput>
80105f62:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105f65:	83 ec 0c             	sub    $0xc,%esp
80105f68:	ff 75 f0             	pushl  -0x10(%ebp)
80105f6b:	e8 76 ba ff ff       	call   801019e6 <ilock>
80105f70:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105f73:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105f78:	75 15                	jne    80105f8f <create+0xa5>
80105f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f7d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f81:	66 83 f8 02          	cmp    $0x2,%ax
80105f85:	75 08                	jne    80105f8f <create+0xa5>
      return ip;
80105f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f8a:	e9 2b 01 00 00       	jmp    801060ba <create+0x1d0>
    iunlockput(ip);
80105f8f:	83 ec 0c             	sub    $0xc,%esp
80105f92:	ff 75 f0             	pushl  -0x10(%ebp)
80105f95:	e8 0c bd ff ff       	call   80101ca6 <iunlockput>
80105f9a:	83 c4 10             	add    $0x10,%esp
    return 0;
80105f9d:	b8 00 00 00 00       	mov    $0x0,%eax
80105fa2:	e9 13 01 00 00       	jmp    801060ba <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105fa7:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fae:	8b 00                	mov    (%eax),%eax
80105fb0:	83 ec 08             	sub    $0x8,%esp
80105fb3:	52                   	push   %edx
80105fb4:	50                   	push   %eax
80105fb5:	e8 7b b7 ff ff       	call   80101735 <ialloc>
80105fba:	83 c4 10             	add    $0x10,%esp
80105fbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fc4:	75 0d                	jne    80105fd3 <create+0xe9>
    panic("create: ialloc");
80105fc6:	83 ec 0c             	sub    $0xc,%esp
80105fc9:	68 27 8e 10 80       	push   $0x80108e27
80105fce:	e8 0f a6 ff ff       	call   801005e2 <panic>

  ilock(ip);
80105fd3:	83 ec 0c             	sub    $0xc,%esp
80105fd6:	ff 75 f0             	pushl  -0x10(%ebp)
80105fd9:	e8 08 ba ff ff       	call   801019e6 <ilock>
80105fde:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe4:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105fe8:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fef:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105ff3:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ffa:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106000:	83 ec 0c             	sub    $0xc,%esp
80106003:	ff 75 f0             	pushl  -0x10(%ebp)
80106006:	e8 01 b8 ff ff       	call   8010180c <iupdate>
8010600b:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010600e:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106013:	75 6a                	jne    8010607f <create+0x195>
    dp->nlink++;  // for ".."
80106015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106018:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010601c:	83 c0 01             	add    $0x1,%eax
8010601f:	89 c2                	mov    %eax,%edx
80106021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106024:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106028:	83 ec 0c             	sub    $0xc,%esp
8010602b:	ff 75 f4             	pushl  -0xc(%ebp)
8010602e:	e8 d9 b7 ff ff       	call   8010180c <iupdate>
80106033:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106036:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106039:	8b 40 04             	mov    0x4(%eax),%eax
8010603c:	83 ec 04             	sub    $0x4,%esp
8010603f:	50                   	push   %eax
80106040:	68 01 8e 10 80       	push   $0x80108e01
80106045:	ff 75 f0             	pushl  -0x10(%ebp)
80106048:	e8 bb c2 ff ff       	call   80102308 <dirlink>
8010604d:	83 c4 10             	add    $0x10,%esp
80106050:	85 c0                	test   %eax,%eax
80106052:	78 1e                	js     80106072 <create+0x188>
80106054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106057:	8b 40 04             	mov    0x4(%eax),%eax
8010605a:	83 ec 04             	sub    $0x4,%esp
8010605d:	50                   	push   %eax
8010605e:	68 03 8e 10 80       	push   $0x80108e03
80106063:	ff 75 f0             	pushl  -0x10(%ebp)
80106066:	e8 9d c2 ff ff       	call   80102308 <dirlink>
8010606b:	83 c4 10             	add    $0x10,%esp
8010606e:	85 c0                	test   %eax,%eax
80106070:	79 0d                	jns    8010607f <create+0x195>
      panic("create dots");
80106072:	83 ec 0c             	sub    $0xc,%esp
80106075:	68 36 8e 10 80       	push   $0x80108e36
8010607a:	e8 63 a5 ff ff       	call   801005e2 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010607f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106082:	8b 40 04             	mov    0x4(%eax),%eax
80106085:	83 ec 04             	sub    $0x4,%esp
80106088:	50                   	push   %eax
80106089:	8d 45 de             	lea    -0x22(%ebp),%eax
8010608c:	50                   	push   %eax
8010608d:	ff 75 f4             	pushl  -0xc(%ebp)
80106090:	e8 73 c2 ff ff       	call   80102308 <dirlink>
80106095:	83 c4 10             	add    $0x10,%esp
80106098:	85 c0                	test   %eax,%eax
8010609a:	79 0d                	jns    801060a9 <create+0x1bf>
    panic("create: dirlink");
8010609c:	83 ec 0c             	sub    $0xc,%esp
8010609f:	68 42 8e 10 80       	push   $0x80108e42
801060a4:	e8 39 a5 ff ff       	call   801005e2 <panic>

  iunlockput(dp);
801060a9:	83 ec 0c             	sub    $0xc,%esp
801060ac:	ff 75 f4             	pushl  -0xc(%ebp)
801060af:	e8 f2 bb ff ff       	call   80101ca6 <iunlockput>
801060b4:	83 c4 10             	add    $0x10,%esp

  return ip;
801060b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801060ba:	c9                   	leave  
801060bb:	c3                   	ret    

801060bc <sys_open>:

int
sys_open(void)
{
801060bc:	55                   	push   %ebp
801060bd:	89 e5                	mov    %esp,%ebp
801060bf:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801060c2:	83 ec 08             	sub    $0x8,%esp
801060c5:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060c8:	50                   	push   %eax
801060c9:	6a 00                	push   $0x0
801060cb:	e8 eb f6 ff ff       	call   801057bb <argstr>
801060d0:	83 c4 10             	add    $0x10,%esp
801060d3:	85 c0                	test   %eax,%eax
801060d5:	78 15                	js     801060ec <sys_open+0x30>
801060d7:	83 ec 08             	sub    $0x8,%esp
801060da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060dd:	50                   	push   %eax
801060de:	6a 01                	push   $0x1
801060e0:	e8 51 f6 ff ff       	call   80105736 <argint>
801060e5:	83 c4 10             	add    $0x10,%esp
801060e8:	85 c0                	test   %eax,%eax
801060ea:	79 0a                	jns    801060f6 <sys_open+0x3a>
    return -1;
801060ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060f1:	e9 61 01 00 00       	jmp    80106257 <sys_open+0x19b>

  begin_op();
801060f6:	e8 21 d5 ff ff       	call   8010361c <begin_op>

  if(omode & O_CREATE){
801060fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060fe:	25 00 02 00 00       	and    $0x200,%eax
80106103:	85 c0                	test   %eax,%eax
80106105:	74 2a                	je     80106131 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106107:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010610a:	6a 00                	push   $0x0
8010610c:	6a 00                	push   $0x0
8010610e:	6a 02                	push   $0x2
80106110:	50                   	push   %eax
80106111:	e8 d4 fd ff ff       	call   80105eea <create>
80106116:	83 c4 10             	add    $0x10,%esp
80106119:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010611c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106120:	75 75                	jne    80106197 <sys_open+0xdb>
      end_op();
80106122:	e8 81 d5 ff ff       	call   801036a8 <end_op>
      return -1;
80106127:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010612c:	e9 26 01 00 00       	jmp    80106257 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106131:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106134:	83 ec 0c             	sub    $0xc,%esp
80106137:	50                   	push   %eax
80106138:	e8 67 c4 ff ff       	call   801025a4 <namei>
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106143:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106147:	75 0f                	jne    80106158 <sys_open+0x9c>
      end_op();
80106149:	e8 5a d5 ff ff       	call   801036a8 <end_op>
      return -1;
8010614e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106153:	e9 ff 00 00 00       	jmp    80106257 <sys_open+0x19b>
    }
    ilock(ip);
80106158:	83 ec 0c             	sub    $0xc,%esp
8010615b:	ff 75 f4             	pushl  -0xc(%ebp)
8010615e:	e8 83 b8 ff ff       	call   801019e6 <ilock>
80106163:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106166:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106169:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010616d:	66 83 f8 01          	cmp    $0x1,%ax
80106171:	75 24                	jne    80106197 <sys_open+0xdb>
80106173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106176:	85 c0                	test   %eax,%eax
80106178:	74 1d                	je     80106197 <sys_open+0xdb>
      iunlockput(ip);
8010617a:	83 ec 0c             	sub    $0xc,%esp
8010617d:	ff 75 f4             	pushl  -0xc(%ebp)
80106180:	e8 21 bb ff ff       	call   80101ca6 <iunlockput>
80106185:	83 c4 10             	add    $0x10,%esp
      end_op();
80106188:	e8 1b d5 ff ff       	call   801036a8 <end_op>
      return -1;
8010618d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106192:	e9 c0 00 00 00       	jmp    80106257 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106197:	e8 73 ae ff ff       	call   8010100f <filealloc>
8010619c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010619f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061a3:	74 17                	je     801061bc <sys_open+0x100>
801061a5:	83 ec 0c             	sub    $0xc,%esp
801061a8:	ff 75 f0             	pushl  -0x10(%ebp)
801061ab:	e8 37 f7 ff ff       	call   801058e7 <fdalloc>
801061b0:	83 c4 10             	add    $0x10,%esp
801061b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801061b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801061ba:	79 2e                	jns    801061ea <sys_open+0x12e>
    if(f)
801061bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061c0:	74 0e                	je     801061d0 <sys_open+0x114>
      fileclose(f);
801061c2:	83 ec 0c             	sub    $0xc,%esp
801061c5:	ff 75 f0             	pushl  -0x10(%ebp)
801061c8:	e8 00 af ff ff       	call   801010cd <fileclose>
801061cd:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801061d0:	83 ec 0c             	sub    $0xc,%esp
801061d3:	ff 75 f4             	pushl  -0xc(%ebp)
801061d6:	e8 cb ba ff ff       	call   80101ca6 <iunlockput>
801061db:	83 c4 10             	add    $0x10,%esp
    end_op();
801061de:	e8 c5 d4 ff ff       	call   801036a8 <end_op>
    return -1;
801061e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061e8:	eb 6d                	jmp    80106257 <sys_open+0x19b>
  }
  iunlock(ip);
801061ea:	83 ec 0c             	sub    $0xc,%esp
801061ed:	ff 75 f4             	pushl  -0xc(%ebp)
801061f0:	e8 4f b9 ff ff       	call   80101b44 <iunlock>
801061f5:	83 c4 10             	add    $0x10,%esp
  end_op();
801061f8:	e8 ab d4 ff ff       	call   801036a8 <end_op>

  f->type = FD_INODE;
801061fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106200:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106206:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106209:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010620c:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010620f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106212:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010621c:	83 e0 01             	and    $0x1,%eax
8010621f:	85 c0                	test   %eax,%eax
80106221:	0f 94 c0             	sete   %al
80106224:	89 c2                	mov    %eax,%edx
80106226:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106229:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010622c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010622f:	83 e0 01             	and    $0x1,%eax
80106232:	85 c0                	test   %eax,%eax
80106234:	75 0a                	jne    80106240 <sys_open+0x184>
80106236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106239:	83 e0 02             	and    $0x2,%eax
8010623c:	85 c0                	test   %eax,%eax
8010623e:	74 07                	je     80106247 <sys_open+0x18b>
80106240:	b8 01 00 00 00       	mov    $0x1,%eax
80106245:	eb 05                	jmp    8010624c <sys_open+0x190>
80106247:	b8 00 00 00 00       	mov    $0x0,%eax
8010624c:	89 c2                	mov    %eax,%edx
8010624e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106251:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106254:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106257:	c9                   	leave  
80106258:	c3                   	ret    

80106259 <sys_mkdir>:

int
sys_mkdir(void)
{
80106259:	55                   	push   %ebp
8010625a:	89 e5                	mov    %esp,%ebp
8010625c:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010625f:	e8 b8 d3 ff ff       	call   8010361c <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106264:	83 ec 08             	sub    $0x8,%esp
80106267:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010626a:	50                   	push   %eax
8010626b:	6a 00                	push   $0x0
8010626d:	e8 49 f5 ff ff       	call   801057bb <argstr>
80106272:	83 c4 10             	add    $0x10,%esp
80106275:	85 c0                	test   %eax,%eax
80106277:	78 1b                	js     80106294 <sys_mkdir+0x3b>
80106279:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010627c:	6a 00                	push   $0x0
8010627e:	6a 00                	push   $0x0
80106280:	6a 01                	push   $0x1
80106282:	50                   	push   %eax
80106283:	e8 62 fc ff ff       	call   80105eea <create>
80106288:	83 c4 10             	add    $0x10,%esp
8010628b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010628e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106292:	75 0c                	jne    801062a0 <sys_mkdir+0x47>
    end_op();
80106294:	e8 0f d4 ff ff       	call   801036a8 <end_op>
    return -1;
80106299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010629e:	eb 18                	jmp    801062b8 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801062a0:	83 ec 0c             	sub    $0xc,%esp
801062a3:	ff 75 f4             	pushl  -0xc(%ebp)
801062a6:	e8 fb b9 ff ff       	call   80101ca6 <iunlockput>
801062ab:	83 c4 10             	add    $0x10,%esp
  end_op();
801062ae:	e8 f5 d3 ff ff       	call   801036a8 <end_op>
  return 0;
801062b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062b8:	c9                   	leave  
801062b9:	c3                   	ret    

801062ba <sys_mknod>:

int
sys_mknod(void)
{
801062ba:	55                   	push   %ebp
801062bb:	89 e5                	mov    %esp,%ebp
801062bd:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801062c0:	e8 57 d3 ff ff       	call   8010361c <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801062c5:	83 ec 08             	sub    $0x8,%esp
801062c8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062cb:	50                   	push   %eax
801062cc:	6a 00                	push   $0x0
801062ce:	e8 e8 f4 ff ff       	call   801057bb <argstr>
801062d3:	83 c4 10             	add    $0x10,%esp
801062d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062dd:	78 4f                	js     8010632e <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801062df:	83 ec 08             	sub    $0x8,%esp
801062e2:	8d 45 e8             	lea    -0x18(%ebp),%eax
801062e5:	50                   	push   %eax
801062e6:	6a 01                	push   $0x1
801062e8:	e8 49 f4 ff ff       	call   80105736 <argint>
801062ed:	83 c4 10             	add    $0x10,%esp
  if((len=argstr(0, &path)) < 0 ||
801062f0:	85 c0                	test   %eax,%eax
801062f2:	78 3a                	js     8010632e <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
801062f4:	83 ec 08             	sub    $0x8,%esp
801062f7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062fa:	50                   	push   %eax
801062fb:	6a 02                	push   $0x2
801062fd:	e8 34 f4 ff ff       	call   80105736 <argint>
80106302:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80106305:	85 c0                	test   %eax,%eax
80106307:	78 25                	js     8010632e <sys_mknod+0x74>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010630c:	0f bf c8             	movswl %ax,%ecx
8010630f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106312:	0f bf d0             	movswl %ax,%edx
80106315:	8b 45 ec             	mov    -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
80106318:	51                   	push   %ecx
80106319:	52                   	push   %edx
8010631a:	6a 03                	push   $0x3
8010631c:	50                   	push   %eax
8010631d:	e8 c8 fb ff ff       	call   80105eea <create>
80106322:	83 c4 10             	add    $0x10,%esp
80106325:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106328:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010632c:	75 0c                	jne    8010633a <sys_mknod+0x80>
    end_op();
8010632e:	e8 75 d3 ff ff       	call   801036a8 <end_op>
    return -1;
80106333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106338:	eb 18                	jmp    80106352 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010633a:	83 ec 0c             	sub    $0xc,%esp
8010633d:	ff 75 f0             	pushl  -0x10(%ebp)
80106340:	e8 61 b9 ff ff       	call   80101ca6 <iunlockput>
80106345:	83 c4 10             	add    $0x10,%esp
  end_op();
80106348:	e8 5b d3 ff ff       	call   801036a8 <end_op>
  return 0;
8010634d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106352:	c9                   	leave  
80106353:	c3                   	ret    

80106354 <sys_chdir>:

int
sys_chdir(void)
{
80106354:	55                   	push   %ebp
80106355:	89 e5                	mov    %esp,%ebp
80106357:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010635a:	e8 bd d2 ff ff       	call   8010361c <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010635f:	83 ec 08             	sub    $0x8,%esp
80106362:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106365:	50                   	push   %eax
80106366:	6a 00                	push   $0x0
80106368:	e8 4e f4 ff ff       	call   801057bb <argstr>
8010636d:	83 c4 10             	add    $0x10,%esp
80106370:	85 c0                	test   %eax,%eax
80106372:	78 18                	js     8010638c <sys_chdir+0x38>
80106374:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106377:	83 ec 0c             	sub    $0xc,%esp
8010637a:	50                   	push   %eax
8010637b:	e8 24 c2 ff ff       	call   801025a4 <namei>
80106380:	83 c4 10             	add    $0x10,%esp
80106383:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106386:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010638a:	75 0c                	jne    80106398 <sys_chdir+0x44>
    end_op();
8010638c:	e8 17 d3 ff ff       	call   801036a8 <end_op>
    return -1;
80106391:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106396:	eb 6e                	jmp    80106406 <sys_chdir+0xb2>
  }
  ilock(ip);
80106398:	83 ec 0c             	sub    $0xc,%esp
8010639b:	ff 75 f4             	pushl  -0xc(%ebp)
8010639e:	e8 43 b6 ff ff       	call   801019e6 <ilock>
801063a3:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801063a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801063ad:	66 83 f8 01          	cmp    $0x1,%ax
801063b1:	74 1a                	je     801063cd <sys_chdir+0x79>
    iunlockput(ip);
801063b3:	83 ec 0c             	sub    $0xc,%esp
801063b6:	ff 75 f4             	pushl  -0xc(%ebp)
801063b9:	e8 e8 b8 ff ff       	call   80101ca6 <iunlockput>
801063be:	83 c4 10             	add    $0x10,%esp
    end_op();
801063c1:	e8 e2 d2 ff ff       	call   801036a8 <end_op>
    return -1;
801063c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063cb:	eb 39                	jmp    80106406 <sys_chdir+0xb2>
  }
  iunlock(ip);
801063cd:	83 ec 0c             	sub    $0xc,%esp
801063d0:	ff 75 f4             	pushl  -0xc(%ebp)
801063d3:	e8 6c b7 ff ff       	call   80101b44 <iunlock>
801063d8:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801063db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063e1:	8b 40 68             	mov    0x68(%eax),%eax
801063e4:	83 ec 0c             	sub    $0xc,%esp
801063e7:	50                   	push   %eax
801063e8:	e8 c9 b7 ff ff       	call   80101bb6 <iput>
801063ed:	83 c4 10             	add    $0x10,%esp
  end_op();
801063f0:	e8 b3 d2 ff ff       	call   801036a8 <end_op>
  proc->cwd = ip;
801063f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063fe:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106401:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106406:	c9                   	leave  
80106407:	c3                   	ret    

80106408 <sys_exec>:

int
sys_exec(void)
{
80106408:	55                   	push   %ebp
80106409:	89 e5                	mov    %esp,%ebp
8010640b:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106411:	83 ec 08             	sub    $0x8,%esp
80106414:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106417:	50                   	push   %eax
80106418:	6a 00                	push   $0x0
8010641a:	e8 9c f3 ff ff       	call   801057bb <argstr>
8010641f:	83 c4 10             	add    $0x10,%esp
80106422:	85 c0                	test   %eax,%eax
80106424:	78 18                	js     8010643e <sys_exec+0x36>
80106426:	83 ec 08             	sub    $0x8,%esp
80106429:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010642f:	50                   	push   %eax
80106430:	6a 01                	push   $0x1
80106432:	e8 ff f2 ff ff       	call   80105736 <argint>
80106437:	83 c4 10             	add    $0x10,%esp
8010643a:	85 c0                	test   %eax,%eax
8010643c:	79 0a                	jns    80106448 <sys_exec+0x40>
    return -1;
8010643e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106443:	e9 c6 00 00 00       	jmp    8010650e <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106448:	83 ec 04             	sub    $0x4,%esp
8010644b:	68 80 00 00 00       	push   $0x80
80106450:	6a 00                	push   $0x0
80106452:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106458:	50                   	push   %eax
80106459:	e8 b3 ef ff ff       	call   80105411 <memset>
8010645e:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106461:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106468:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010646b:	83 f8 1f             	cmp    $0x1f,%eax
8010646e:	76 0a                	jbe    8010647a <sys_exec+0x72>
      return -1;
80106470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106475:	e9 94 00 00 00       	jmp    8010650e <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010647a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010647d:	c1 e0 02             	shl    $0x2,%eax
80106480:	89 c2                	mov    %eax,%edx
80106482:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106488:	01 c2                	add    %eax,%edx
8010648a:	83 ec 08             	sub    $0x8,%esp
8010648d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106493:	50                   	push   %eax
80106494:	52                   	push   %edx
80106495:	e8 00 f2 ff ff       	call   8010569a <fetchint>
8010649a:	83 c4 10             	add    $0x10,%esp
8010649d:	85 c0                	test   %eax,%eax
8010649f:	79 07                	jns    801064a8 <sys_exec+0xa0>
      return -1;
801064a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064a6:	eb 66                	jmp    8010650e <sys_exec+0x106>
    if(uarg == 0){
801064a8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801064ae:	85 c0                	test   %eax,%eax
801064b0:	75 27                	jne    801064d9 <sys_exec+0xd1>
      argv[i] = 0;
801064b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b5:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801064bc:	00 00 00 00 
      break;
801064c0:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801064c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064c4:	83 ec 08             	sub    $0x8,%esp
801064c7:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801064cd:	52                   	push   %edx
801064ce:	50                   	push   %eax
801064cf:	e8 19 a7 ff ff       	call   80100bed <exec>
801064d4:	83 c4 10             	add    $0x10,%esp
801064d7:	eb 35                	jmp    8010650e <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
801064d9:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801064df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064e2:	c1 e2 02             	shl    $0x2,%edx
801064e5:	01 c2                	add    %eax,%edx
801064e7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801064ed:	83 ec 08             	sub    $0x8,%esp
801064f0:	52                   	push   %edx
801064f1:	50                   	push   %eax
801064f2:	e8 dd f1 ff ff       	call   801056d4 <fetchstr>
801064f7:	83 c4 10             	add    $0x10,%esp
801064fa:	85 c0                	test   %eax,%eax
801064fc:	79 07                	jns    80106505 <sys_exec+0xfd>
      return -1;
801064fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106503:	eb 09                	jmp    8010650e <sys_exec+0x106>
  for(i=0;; i++){
80106505:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80106509:	e9 5a ff ff ff       	jmp    80106468 <sys_exec+0x60>
}
8010650e:	c9                   	leave  
8010650f:	c3                   	ret    

80106510 <sys_pipe>:

int
sys_pipe(void)
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106516:	83 ec 04             	sub    $0x4,%esp
80106519:	6a 08                	push   $0x8
8010651b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010651e:	50                   	push   %eax
8010651f:	6a 00                	push   $0x0
80106521:	e8 38 f2 ff ff       	call   8010575e <argptr>
80106526:	83 c4 10             	add    $0x10,%esp
80106529:	85 c0                	test   %eax,%eax
8010652b:	79 0a                	jns    80106537 <sys_pipe+0x27>
    return -1;
8010652d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106532:	e9 af 00 00 00       	jmp    801065e6 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106537:	83 ec 08             	sub    $0x8,%esp
8010653a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010653d:	50                   	push   %eax
8010653e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106541:	50                   	push   %eax
80106542:	e8 c9 db ff ff       	call   80104110 <pipealloc>
80106547:	83 c4 10             	add    $0x10,%esp
8010654a:	85 c0                	test   %eax,%eax
8010654c:	79 0a                	jns    80106558 <sys_pipe+0x48>
    return -1;
8010654e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106553:	e9 8e 00 00 00       	jmp    801065e6 <sys_pipe+0xd6>
  fd0 = -1;
80106558:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010655f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106562:	83 ec 0c             	sub    $0xc,%esp
80106565:	50                   	push   %eax
80106566:	e8 7c f3 ff ff       	call   801058e7 <fdalloc>
8010656b:	83 c4 10             	add    $0x10,%esp
8010656e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106575:	78 18                	js     8010658f <sys_pipe+0x7f>
80106577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010657a:	83 ec 0c             	sub    $0xc,%esp
8010657d:	50                   	push   %eax
8010657e:	e8 64 f3 ff ff       	call   801058e7 <fdalloc>
80106583:	83 c4 10             	add    $0x10,%esp
80106586:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106589:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010658d:	79 3f                	jns    801065ce <sys_pipe+0xbe>
    if(fd0 >= 0)
8010658f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106593:	78 14                	js     801065a9 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106595:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010659b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010659e:	83 c2 08             	add    $0x8,%edx
801065a1:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801065a8:	00 
    fileclose(rf);
801065a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065ac:	83 ec 0c             	sub    $0xc,%esp
801065af:	50                   	push   %eax
801065b0:	e8 18 ab ff ff       	call   801010cd <fileclose>
801065b5:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801065b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065bb:	83 ec 0c             	sub    $0xc,%esp
801065be:	50                   	push   %eax
801065bf:	e8 09 ab ff ff       	call   801010cd <fileclose>
801065c4:	83 c4 10             	add    $0x10,%esp
    return -1;
801065c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065cc:	eb 18                	jmp    801065e6 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801065ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801065d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065d4:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801065d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801065d9:	8d 50 04             	lea    0x4(%eax),%edx
801065dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065df:	89 02                	mov    %eax,(%edx)
  return 0;
801065e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065e6:	c9                   	leave  
801065e7:	c3                   	ret    

801065e8 <sys_fork>:
#include "proc.h"
#include "spinlock.h"

int
sys_fork(void)
{
801065e8:	55                   	push   %ebp
801065e9:	89 e5                	mov    %esp,%ebp
801065eb:	83 ec 08             	sub    $0x8,%esp
  return fork();
801065ee:	e8 3f e2 ff ff       	call   80104832 <fork>
}
801065f3:	c9                   	leave  
801065f4:	c3                   	ret    

801065f5 <sys_exit>:
	struct proc proc[NPROC];
} ptable;

int
sys_exit(void)
{
801065f5:	55                   	push   %ebp
801065f6:	89 e5                	mov    %esp,%ebp
801065f8:	83 ec 08             	sub    $0x8,%esp
  exit();
801065fb:	e8 c3 e3 ff ff       	call   801049c3 <exit>
  return 0;  // not reached
80106600:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106605:	c9                   	leave  
80106606:	c3                   	ret    

80106607 <sys_wait>:

int
sys_wait(void)
{
80106607:	55                   	push   %ebp
80106608:	89 e5                	mov    %esp,%ebp
8010660a:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010660d:	e8 e9 e4 ff ff       	call   80104afb <wait>
}
80106612:	c9                   	leave  
80106613:	c3                   	ret    

80106614 <sys_kill>:

int
sys_kill(void)
{
80106614:	55                   	push   %ebp
80106615:	89 e5                	mov    %esp,%ebp
80106617:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010661a:	83 ec 08             	sub    $0x8,%esp
8010661d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106620:	50                   	push   %eax
80106621:	6a 00                	push   $0x0
80106623:	e8 0e f1 ff ff       	call   80105736 <argint>
80106628:	83 c4 10             	add    $0x10,%esp
8010662b:	85 c0                	test   %eax,%eax
8010662d:	79 07                	jns    80106636 <sys_kill+0x22>
    return -1;
8010662f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106634:	eb 0f                	jmp    80106645 <sys_kill+0x31>
  return kill(pid);
80106636:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106639:	83 ec 0c             	sub    $0xc,%esp
8010663c:	50                   	push   %eax
8010663d:	e8 95 e9 ff ff       	call   80104fd7 <kill>
80106642:	83 c4 10             	add    $0x10,%esp
}
80106645:	c9                   	leave  
80106646:	c3                   	ret    

80106647 <sys_getpid>:

int
sys_getpid(void)
{
80106647:	55                   	push   %ebp
80106648:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010664a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106650:	8b 40 10             	mov    0x10(%eax),%eax
}
80106653:	5d                   	pop    %ebp
80106654:	c3                   	ret    

80106655 <sys_sbrk>:

int
sys_sbrk(void)
{
80106655:	55                   	push   %ebp
80106656:	89 e5                	mov    %esp,%ebp
80106658:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010665b:	83 ec 08             	sub    $0x8,%esp
8010665e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106661:	50                   	push   %eax
80106662:	6a 00                	push   $0x0
80106664:	e8 cd f0 ff ff       	call   80105736 <argint>
80106669:	83 c4 10             	add    $0x10,%esp
8010666c:	85 c0                	test   %eax,%eax
8010666e:	79 07                	jns    80106677 <sys_sbrk+0x22>
    return -1;
80106670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106675:	eb 28                	jmp    8010669f <sys_sbrk+0x4a>
  addr = proc->sz;
80106677:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010667d:	8b 00                	mov    (%eax),%eax
8010667f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106682:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106685:	83 ec 0c             	sub    $0xc,%esp
80106688:	50                   	push   %eax
80106689:	e8 01 e1 ff ff       	call   8010478f <growproc>
8010668e:	83 c4 10             	add    $0x10,%esp
80106691:	85 c0                	test   %eax,%eax
80106693:	79 07                	jns    8010669c <sys_sbrk+0x47>
    return -1;
80106695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010669a:	eb 03                	jmp    8010669f <sys_sbrk+0x4a>
  return addr;
8010669c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010669f:	c9                   	leave  
801066a0:	c3                   	ret    

801066a1 <sys_sleep>:

int
sys_sleep(void)
{
801066a1:	55                   	push   %ebp
801066a2:	89 e5                	mov    %esp,%ebp
801066a4:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801066a7:	83 ec 08             	sub    $0x8,%esp
801066aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066ad:	50                   	push   %eax
801066ae:	6a 00                	push   $0x0
801066b0:	e8 81 f0 ff ff       	call   80105736 <argint>
801066b5:	83 c4 10             	add    $0x10,%esp
801066b8:	85 c0                	test   %eax,%eax
801066ba:	79 07                	jns    801066c3 <sys_sleep+0x22>
    return -1;
801066bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066c1:	eb 77                	jmp    8010673a <sys_sleep+0x99>
  acquire(&tickslock);
801066c3:	83 ec 0c             	sub    $0xc,%esp
801066c6:	68 a0 63 11 80       	push   $0x801163a0
801066cb:	e8 de ea ff ff       	call   801051ae <acquire>
801066d0:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801066d3:	a1 e0 6b 11 80       	mov    0x80116be0,%eax
801066d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801066db:	eb 39                	jmp    80106716 <sys_sleep+0x75>
    if(proc->killed){
801066dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066e3:	8b 40 24             	mov    0x24(%eax),%eax
801066e6:	85 c0                	test   %eax,%eax
801066e8:	74 17                	je     80106701 <sys_sleep+0x60>
      release(&tickslock);
801066ea:	83 ec 0c             	sub    $0xc,%esp
801066ed:	68 a0 63 11 80       	push   $0x801163a0
801066f2:	e8 1e eb ff ff       	call   80105215 <release>
801066f7:	83 c4 10             	add    $0x10,%esp
      return -1;
801066fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ff:	eb 39                	jmp    8010673a <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106701:	83 ec 08             	sub    $0x8,%esp
80106704:	68 a0 63 11 80       	push   $0x801163a0
80106709:	68 e0 6b 11 80       	push   $0x80116be0
8010670e:	e8 a2 e7 ff ff       	call   80104eb5 <sleep>
80106713:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106716:	a1 e0 6b 11 80       	mov    0x80116be0,%eax
8010671b:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010671e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106721:	39 d0                	cmp    %edx,%eax
80106723:	72 b8                	jb     801066dd <sys_sleep+0x3c>
  }
  release(&tickslock);
80106725:	83 ec 0c             	sub    $0xc,%esp
80106728:	68 a0 63 11 80       	push   $0x801163a0
8010672d:	e8 e3 ea ff ff       	call   80105215 <release>
80106732:	83 c4 10             	add    $0x10,%esp
  return 0;
80106735:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010673a:	c9                   	leave  
8010673b:	c3                   	ret    

8010673c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010673c:	55                   	push   %ebp
8010673d:	89 e5                	mov    %esp,%ebp
8010673f:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80106742:	83 ec 0c             	sub    $0xc,%esp
80106745:	68 a0 63 11 80       	push   $0x801163a0
8010674a:	e8 5f ea ff ff       	call   801051ae <acquire>
8010674f:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106752:	a1 e0 6b 11 80       	mov    0x80116be0,%eax
80106757:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010675a:	83 ec 0c             	sub    $0xc,%esp
8010675d:	68 a0 63 11 80       	push   $0x801163a0
80106762:	e8 ae ea ff ff       	call   80105215 <release>
80106767:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010676a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010676d:	c9                   	leave  
8010676e:	c3                   	ret    

8010676f <sys_gettime>:

int
sys_gettime(void) {
8010676f:	55                   	push   %ebp
80106770:	89 e5                	mov    %esp,%ebp
80106772:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;
  if (argptr(0, (char **)&d, sizeof(struct rtcdate)) < 0)
80106775:	83 ec 04             	sub    $0x4,%esp
80106778:	6a 18                	push   $0x18
8010677a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010677d:	50                   	push   %eax
8010677e:	6a 00                	push   $0x0
80106780:	e8 d9 ef ff ff       	call   8010575e <argptr>
80106785:	83 c4 10             	add    $0x10,%esp
80106788:	85 c0                	test   %eax,%eax
8010678a:	79 07                	jns    80106793 <sys_gettime+0x24>
      return -1;
8010678c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106791:	eb 14                	jmp    801067a7 <sys_gettime+0x38>
  cmostime(d);
80106793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106796:	83 ec 0c             	sub    $0xc,%esp
80106799:	50                   	push   %eax
8010679a:	e8 a5 ca ff ff       	call   80103244 <cmostime>
8010679f:	83 c4 10             	add    $0x10,%esp
  return 0;
801067a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067a7:	c9                   	leave  
801067a8:	c3                   	ret    

801067a9 <sys_settickets>:

//Added for lottery sched
int
sys_settickets(void)
{
801067a9:	55                   	push   %ebp
801067aa:	89 e5                	mov    %esp,%ebp
801067ac:	83 ec 18             	sub    $0x18,%esp
	int num;
	//cprintf("in settickets enter");
	if(argint(0, &num) < 0)
801067af:	83 ec 08             	sub    $0x8,%esp
801067b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067b5:	50                   	push   %eax
801067b6:	6a 00                	push   $0x0
801067b8:	e8 79 ef ff ff       	call   80105736 <argint>
801067bd:	83 c4 10             	add    $0x10,%esp
801067c0:	85 c0                	test   %eax,%eax
801067c2:	79 07                	jns    801067cb <sys_settickets+0x22>
			return 	0;
801067c4:	b8 00 00 00 00       	mov    $0x0,%eax
801067c9:	eb 0f                	jmp    801067da <sys_settickets+0x31>
	proc->tickets = num;
801067cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067d4:	89 50 7c             	mov    %edx,0x7c(%eax)
	//cprintf("in settickets exit");
	return num;
801067d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801067da:	c9                   	leave  
801067db:	c3                   	ret    

801067dc <outb>:
{
801067dc:	55                   	push   %ebp
801067dd:	89 e5                	mov    %esp,%ebp
801067df:	83 ec 08             	sub    $0x8,%esp
801067e2:	8b 55 08             	mov    0x8(%ebp),%edx
801067e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801067e8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801067ec:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067ef:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801067f3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801067f7:	ee                   	out    %al,(%dx)
}
801067f8:	90                   	nop
801067f9:	c9                   	leave  
801067fa:	c3                   	ret    

801067fb <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801067fb:	55                   	push   %ebp
801067fc:	89 e5                	mov    %esp,%ebp
801067fe:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106801:	6a 34                	push   $0x34
80106803:	6a 43                	push   $0x43
80106805:	e8 d2 ff ff ff       	call   801067dc <outb>
8010680a:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
8010680d:	68 9c 00 00 00       	push   $0x9c
80106812:	6a 40                	push   $0x40
80106814:	e8 c3 ff ff ff       	call   801067dc <outb>
80106819:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010681c:	6a 2e                	push   $0x2e
8010681e:	6a 40                	push   $0x40
80106820:	e8 b7 ff ff ff       	call   801067dc <outb>
80106825:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106828:	83 ec 0c             	sub    $0xc,%esp
8010682b:	6a 00                	push   $0x0
8010682d:	e8 c8 d7 ff ff       	call   80103ffa <picenable>
80106832:	83 c4 10             	add    $0x10,%esp
}
80106835:	90                   	nop
80106836:	c9                   	leave  
80106837:	c3                   	ret    

80106838 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106838:	1e                   	push   %ds
  pushl %es
80106839:	06                   	push   %es
  pushl %fs
8010683a:	0f a0                	push   %fs
  pushl %gs
8010683c:	0f a8                	push   %gs
  pushal
8010683e:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010683f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106843:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106845:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106847:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010684b:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
8010684d:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010684f:	54                   	push   %esp
  call trap
80106850:	e8 d7 01 00 00       	call   80106a2c <trap>
  addl $4, %esp
80106855:	83 c4 04             	add    $0x4,%esp

80106858 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106858:	61                   	popa   
  popl %gs
80106859:	0f a9                	pop    %gs
  popl %fs
8010685b:	0f a1                	pop    %fs
  popl %es
8010685d:	07                   	pop    %es
  popl %ds
8010685e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010685f:	83 c4 08             	add    $0x8,%esp
  iret
80106862:	cf                   	iret   

80106863 <lidt>:
{
80106863:	55                   	push   %ebp
80106864:	89 e5                	mov    %esp,%ebp
80106866:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106869:	8b 45 0c             	mov    0xc(%ebp),%eax
8010686c:	83 e8 01             	sub    $0x1,%eax
8010686f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106873:	8b 45 08             	mov    0x8(%ebp),%eax
80106876:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010687a:	8b 45 08             	mov    0x8(%ebp),%eax
8010687d:	c1 e8 10             	shr    $0x10,%eax
80106880:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106884:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106887:	0f 01 18             	lidtl  (%eax)
}
8010688a:	90                   	nop
8010688b:	c9                   	leave  
8010688c:	c3                   	ret    

8010688d <rcr2>:

static inline uint
rcr2(void)
{
8010688d:	55                   	push   %ebp
8010688e:	89 e5                	mov    %esp,%ebp
80106890:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106893:	0f 20 d0             	mov    %cr2,%eax
80106896:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106899:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010689c:	c9                   	leave  
8010689d:	c3                   	ret    

8010689e <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010689e:	55                   	push   %ebp
8010689f:	89 e5                	mov    %esp,%ebp
801068a1:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801068a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801068ab:	e9 c3 00 00 00       	jmp    80106973 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801068b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b3:	8b 04 85 a0 c0 10 80 	mov    -0x7fef3f60(,%eax,4),%eax
801068ba:	89 c2                	mov    %eax,%edx
801068bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068bf:	66 89 14 c5 e0 63 11 	mov    %dx,-0x7fee9c20(,%eax,8)
801068c6:	80 
801068c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ca:	66 c7 04 c5 e2 63 11 	movw   $0x8,-0x7fee9c1e(,%eax,8)
801068d1:	80 08 00 
801068d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068d7:	0f b6 14 c5 e4 63 11 	movzbl -0x7fee9c1c(,%eax,8),%edx
801068de:	80 
801068df:	83 e2 e0             	and    $0xffffffe0,%edx
801068e2:	88 14 c5 e4 63 11 80 	mov    %dl,-0x7fee9c1c(,%eax,8)
801068e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ec:	0f b6 14 c5 e4 63 11 	movzbl -0x7fee9c1c(,%eax,8),%edx
801068f3:	80 
801068f4:	83 e2 1f             	and    $0x1f,%edx
801068f7:	88 14 c5 e4 63 11 80 	mov    %dl,-0x7fee9c1c(,%eax,8)
801068fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106901:	0f b6 14 c5 e5 63 11 	movzbl -0x7fee9c1b(,%eax,8),%edx
80106908:	80 
80106909:	83 e2 f0             	and    $0xfffffff0,%edx
8010690c:	83 ca 0e             	or     $0xe,%edx
8010690f:	88 14 c5 e5 63 11 80 	mov    %dl,-0x7fee9c1b(,%eax,8)
80106916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106919:	0f b6 14 c5 e5 63 11 	movzbl -0x7fee9c1b(,%eax,8),%edx
80106920:	80 
80106921:	83 e2 ef             	and    $0xffffffef,%edx
80106924:	88 14 c5 e5 63 11 80 	mov    %dl,-0x7fee9c1b(,%eax,8)
8010692b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010692e:	0f b6 14 c5 e5 63 11 	movzbl -0x7fee9c1b(,%eax,8),%edx
80106935:	80 
80106936:	83 e2 9f             	and    $0xffffff9f,%edx
80106939:	88 14 c5 e5 63 11 80 	mov    %dl,-0x7fee9c1b(,%eax,8)
80106940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106943:	0f b6 14 c5 e5 63 11 	movzbl -0x7fee9c1b(,%eax,8),%edx
8010694a:	80 
8010694b:	83 ca 80             	or     $0xffffff80,%edx
8010694e:	88 14 c5 e5 63 11 80 	mov    %dl,-0x7fee9c1b(,%eax,8)
80106955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106958:	8b 04 85 a0 c0 10 80 	mov    -0x7fef3f60(,%eax,4),%eax
8010695f:	c1 e8 10             	shr    $0x10,%eax
80106962:	89 c2                	mov    %eax,%edx
80106964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106967:	66 89 14 c5 e6 63 11 	mov    %dx,-0x7fee9c1a(,%eax,8)
8010696e:	80 
  for(i = 0; i < 256; i++)
8010696f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106973:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010697a:	0f 8e 30 ff ff ff    	jle    801068b0 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106980:	a1 a0 c1 10 80       	mov    0x8010c1a0,%eax
80106985:	66 a3 e0 65 11 80    	mov    %ax,0x801165e0
8010698b:	66 c7 05 e2 65 11 80 	movw   $0x8,0x801165e2
80106992:	08 00 
80106994:	0f b6 05 e4 65 11 80 	movzbl 0x801165e4,%eax
8010699b:	83 e0 e0             	and    $0xffffffe0,%eax
8010699e:	a2 e4 65 11 80       	mov    %al,0x801165e4
801069a3:	0f b6 05 e4 65 11 80 	movzbl 0x801165e4,%eax
801069aa:	83 e0 1f             	and    $0x1f,%eax
801069ad:	a2 e4 65 11 80       	mov    %al,0x801165e4
801069b2:	0f b6 05 e5 65 11 80 	movzbl 0x801165e5,%eax
801069b9:	83 c8 0f             	or     $0xf,%eax
801069bc:	a2 e5 65 11 80       	mov    %al,0x801165e5
801069c1:	0f b6 05 e5 65 11 80 	movzbl 0x801165e5,%eax
801069c8:	83 e0 ef             	and    $0xffffffef,%eax
801069cb:	a2 e5 65 11 80       	mov    %al,0x801165e5
801069d0:	0f b6 05 e5 65 11 80 	movzbl 0x801165e5,%eax
801069d7:	83 c8 60             	or     $0x60,%eax
801069da:	a2 e5 65 11 80       	mov    %al,0x801165e5
801069df:	0f b6 05 e5 65 11 80 	movzbl 0x801165e5,%eax
801069e6:	83 c8 80             	or     $0xffffff80,%eax
801069e9:	a2 e5 65 11 80       	mov    %al,0x801165e5
801069ee:	a1 a0 c1 10 80       	mov    0x8010c1a0,%eax
801069f3:	c1 e8 10             	shr    $0x10,%eax
801069f6:	66 a3 e6 65 11 80    	mov    %ax,0x801165e6
  
  initlock(&tickslock, "time");
801069fc:	83 ec 08             	sub    $0x8,%esp
801069ff:	68 54 8e 10 80       	push   $0x80108e54
80106a04:	68 a0 63 11 80       	push   $0x801163a0
80106a09:	e8 7e e7 ff ff       	call   8010518c <initlock>
80106a0e:	83 c4 10             	add    $0x10,%esp
}
80106a11:	90                   	nop
80106a12:	c9                   	leave  
80106a13:	c3                   	ret    

80106a14 <idtinit>:

void
idtinit(void)
{
80106a14:	55                   	push   %ebp
80106a15:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106a17:	68 00 08 00 00       	push   $0x800
80106a1c:	68 e0 63 11 80       	push   $0x801163e0
80106a21:	e8 3d fe ff ff       	call   80106863 <lidt>
80106a26:	83 c4 08             	add    $0x8,%esp
}
80106a29:	90                   	nop
80106a2a:	c9                   	leave  
80106a2b:	c3                   	ret    

80106a2c <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106a2c:	55                   	push   %ebp
80106a2d:	89 e5                	mov    %esp,%ebp
80106a2f:	57                   	push   %edi
80106a30:	56                   	push   %esi
80106a31:	53                   	push   %ebx
80106a32:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106a35:	8b 45 08             	mov    0x8(%ebp),%eax
80106a38:	8b 40 30             	mov    0x30(%eax),%eax
80106a3b:	83 f8 40             	cmp    $0x40,%eax
80106a3e:	75 3e                	jne    80106a7e <trap+0x52>
    if(proc->killed)
80106a40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a46:	8b 40 24             	mov    0x24(%eax),%eax
80106a49:	85 c0                	test   %eax,%eax
80106a4b:	74 05                	je     80106a52 <trap+0x26>
      exit();
80106a4d:	e8 71 df ff ff       	call   801049c3 <exit>
    proc->tf = tf;
80106a52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a58:	8b 55 08             	mov    0x8(%ebp),%edx
80106a5b:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106a5e:	e8 89 ed ff ff       	call   801057ec <syscall>
    if(proc->killed)
80106a63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a69:	8b 40 24             	mov    0x24(%eax),%eax
80106a6c:	85 c0                	test   %eax,%eax
80106a6e:	0f 84 1b 02 00 00    	je     80106c8f <trap+0x263>
      exit();
80106a74:	e8 4a df ff ff       	call   801049c3 <exit>
    return;
80106a79:	e9 11 02 00 00       	jmp    80106c8f <trap+0x263>
  }

  switch(tf->trapno){
80106a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80106a81:	8b 40 30             	mov    0x30(%eax),%eax
80106a84:	83 e8 20             	sub    $0x20,%eax
80106a87:	83 f8 1f             	cmp    $0x1f,%eax
80106a8a:	0f 87 c0 00 00 00    	ja     80106b50 <trap+0x124>
80106a90:	8b 04 85 fc 8e 10 80 	mov    -0x7fef7104(,%eax,4),%eax
80106a97:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106a99:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a9f:	0f b6 00             	movzbl (%eax),%eax
80106aa2:	84 c0                	test   %al,%al
80106aa4:	75 3d                	jne    80106ae3 <trap+0xb7>
      acquire(&tickslock);
80106aa6:	83 ec 0c             	sub    $0xc,%esp
80106aa9:	68 a0 63 11 80       	push   $0x801163a0
80106aae:	e8 fb e6 ff ff       	call   801051ae <acquire>
80106ab3:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106ab6:	a1 e0 6b 11 80       	mov    0x80116be0,%eax
80106abb:	83 c0 01             	add    $0x1,%eax
80106abe:	a3 e0 6b 11 80       	mov    %eax,0x80116be0
      wakeup(&ticks);
80106ac3:	83 ec 0c             	sub    $0xc,%esp
80106ac6:	68 e0 6b 11 80       	push   $0x80116be0
80106acb:	e8 d0 e4 ff ff       	call   80104fa0 <wakeup>
80106ad0:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106ad3:	83 ec 0c             	sub    $0xc,%esp
80106ad6:	68 a0 63 11 80       	push   $0x801163a0
80106adb:	e8 35 e7 ff ff       	call   80105215 <release>
80106ae0:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106ae3:	e8 b9 c5 ff ff       	call   801030a1 <lapiceoi>
    break;
80106ae8:	e9 1c 01 00 00       	jmp    80106c09 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106aed:	e8 c2 bd ff ff       	call   801028b4 <ideintr>
    lapiceoi();
80106af2:	e8 aa c5 ff ff       	call   801030a1 <lapiceoi>
    break;
80106af7:	e9 0d 01 00 00       	jmp    80106c09 <trap+0x1dd>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106afc:	e8 a2 c3 ff ff       	call   80102ea3 <kbdintr>
    lapiceoi();
80106b01:	e8 9b c5 ff ff       	call   801030a1 <lapiceoi>
    break;
80106b06:	e9 fe 00 00 00       	jmp    80106c09 <trap+0x1dd>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106b0b:	e8 60 03 00 00       	call   80106e70 <uartintr>
    lapiceoi();
80106b10:	e8 8c c5 ff ff       	call   801030a1 <lapiceoi>
    break;
80106b15:	e9 ef 00 00 00       	jmp    80106c09 <trap+0x1dd>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1d:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106b20:	8b 45 08             	mov    0x8(%ebp),%eax
80106b23:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b27:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106b2a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b30:	0f b6 00             	movzbl (%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b33:	0f b6 c0             	movzbl %al,%eax
80106b36:	51                   	push   %ecx
80106b37:	52                   	push   %edx
80106b38:	50                   	push   %eax
80106b39:	68 5c 8e 10 80       	push   $0x80108e5c
80106b3e:	e8 d7 98 ff ff       	call   8010041a <cprintf>
80106b43:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106b46:	e8 56 c5 ff ff       	call   801030a1 <lapiceoi>
    break;
80106b4b:	e9 b9 00 00 00       	jmp    80106c09 <trap+0x1dd>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106b50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b56:	85 c0                	test   %eax,%eax
80106b58:	74 11                	je     80106b6b <trap+0x13f>
80106b5a:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106b61:	0f b7 c0             	movzwl %ax,%eax
80106b64:	83 e0 03             	and    $0x3,%eax
80106b67:	85 c0                	test   %eax,%eax
80106b69:	75 40                	jne    80106bab <trap+0x17f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106b6b:	e8 1d fd ff ff       	call   8010688d <rcr2>
80106b70:	89 c3                	mov    %eax,%ebx
80106b72:	8b 45 08             	mov    0x8(%ebp),%eax
80106b75:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106b78:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b7e:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106b81:	0f b6 d0             	movzbl %al,%edx
80106b84:	8b 45 08             	mov    0x8(%ebp),%eax
80106b87:	8b 40 30             	mov    0x30(%eax),%eax
80106b8a:	83 ec 0c             	sub    $0xc,%esp
80106b8d:	53                   	push   %ebx
80106b8e:	51                   	push   %ecx
80106b8f:	52                   	push   %edx
80106b90:	50                   	push   %eax
80106b91:	68 80 8e 10 80       	push   $0x80108e80
80106b96:	e8 7f 98 ff ff       	call   8010041a <cprintf>
80106b9b:	83 c4 20             	add    $0x20,%esp
      panic("trap");
80106b9e:	83 ec 0c             	sub    $0xc,%esp
80106ba1:	68 b2 8e 10 80       	push   $0x80108eb2
80106ba6:	e8 37 9a ff ff       	call   801005e2 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106bab:	e8 dd fc ff ff       	call   8010688d <rcr2>
80106bb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106bb3:	8b 45 08             	mov    0x8(%ebp),%eax
80106bb6:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106bb9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106bbf:	0f b6 00             	movzbl (%eax),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106bc2:	0f b6 d8             	movzbl %al,%ebx
80106bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80106bc8:	8b 48 34             	mov    0x34(%eax),%ecx
80106bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80106bce:	8b 50 30             	mov    0x30(%eax),%edx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106bd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bd7:	8d 78 6c             	lea    0x6c(%eax),%edi
80106bda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106be0:	8b 40 10             	mov    0x10(%eax),%eax
80106be3:	ff 75 e4             	pushl  -0x1c(%ebp)
80106be6:	56                   	push   %esi
80106be7:	53                   	push   %ebx
80106be8:	51                   	push   %ecx
80106be9:	52                   	push   %edx
80106bea:	57                   	push   %edi
80106beb:	50                   	push   %eax
80106bec:	68 b8 8e 10 80       	push   $0x80108eb8
80106bf1:	e8 24 98 ff ff       	call   8010041a <cprintf>
80106bf6:	83 c4 20             	add    $0x20,%esp
            rcr2());
    proc->killed = 1;
80106bf9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bff:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106c06:	eb 01                	jmp    80106c09 <trap+0x1dd>
    break;
80106c08:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106c09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c0f:	85 c0                	test   %eax,%eax
80106c11:	74 24                	je     80106c37 <trap+0x20b>
80106c13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c19:	8b 40 24             	mov    0x24(%eax),%eax
80106c1c:	85 c0                	test   %eax,%eax
80106c1e:	74 17                	je     80106c37 <trap+0x20b>
80106c20:	8b 45 08             	mov    0x8(%ebp),%eax
80106c23:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106c27:	0f b7 c0             	movzwl %ax,%eax
80106c2a:	83 e0 03             	and    $0x3,%eax
80106c2d:	83 f8 03             	cmp    $0x3,%eax
80106c30:	75 05                	jne    80106c37 <trap+0x20b>
    exit();
80106c32:	e8 8c dd ff ff       	call   801049c3 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106c37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c3d:	85 c0                	test   %eax,%eax
80106c3f:	74 1e                	je     80106c5f <trap+0x233>
80106c41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c47:	8b 40 0c             	mov    0xc(%eax),%eax
80106c4a:	83 f8 04             	cmp    $0x4,%eax
80106c4d:	75 10                	jne    80106c5f <trap+0x233>
80106c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80106c52:	8b 40 30             	mov    0x30(%eax),%eax
80106c55:	83 f8 20             	cmp    $0x20,%eax
80106c58:	75 05                	jne    80106c5f <trap+0x233>
    yield();
80106c5a:	e8 d5 e1 ff ff       	call   80104e34 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106c5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c65:	85 c0                	test   %eax,%eax
80106c67:	74 27                	je     80106c90 <trap+0x264>
80106c69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c6f:	8b 40 24             	mov    0x24(%eax),%eax
80106c72:	85 c0                	test   %eax,%eax
80106c74:	74 1a                	je     80106c90 <trap+0x264>
80106c76:	8b 45 08             	mov    0x8(%ebp),%eax
80106c79:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106c7d:	0f b7 c0             	movzwl %ax,%eax
80106c80:	83 e0 03             	and    $0x3,%eax
80106c83:	83 f8 03             	cmp    $0x3,%eax
80106c86:	75 08                	jne    80106c90 <trap+0x264>
    exit();
80106c88:	e8 36 dd ff ff       	call   801049c3 <exit>
80106c8d:	eb 01                	jmp    80106c90 <trap+0x264>
    return;
80106c8f:	90                   	nop
}
80106c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c93:	5b                   	pop    %ebx
80106c94:	5e                   	pop    %esi
80106c95:	5f                   	pop    %edi
80106c96:	5d                   	pop    %ebp
80106c97:	c3                   	ret    

80106c98 <inb>:
{
80106c98:	55                   	push   %ebp
80106c99:	89 e5                	mov    %esp,%ebp
80106c9b:	83 ec 14             	sub    $0x14,%esp
80106c9e:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ca5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106ca9:	89 c2                	mov    %eax,%edx
80106cab:	ec                   	in     (%dx),%al
80106cac:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106caf:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106cb3:	c9                   	leave  
80106cb4:	c3                   	ret    

80106cb5 <outb>:
{
80106cb5:	55                   	push   %ebp
80106cb6:	89 e5                	mov    %esp,%ebp
80106cb8:	83 ec 08             	sub    $0x8,%esp
80106cbb:	8b 55 08             	mov    0x8(%ebp),%edx
80106cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cc1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106cc5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106cc8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106ccc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106cd0:	ee                   	out    %al,(%dx)
}
80106cd1:	90                   	nop
80106cd2:	c9                   	leave  
80106cd3:	c3                   	ret    

80106cd4 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106cd4:	55                   	push   %ebp
80106cd5:	89 e5                	mov    %esp,%ebp
80106cd7:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106cda:	6a 00                	push   $0x0
80106cdc:	68 fa 03 00 00       	push   $0x3fa
80106ce1:	e8 cf ff ff ff       	call   80106cb5 <outb>
80106ce6:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106ce9:	68 80 00 00 00       	push   $0x80
80106cee:	68 fb 03 00 00       	push   $0x3fb
80106cf3:	e8 bd ff ff ff       	call   80106cb5 <outb>
80106cf8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106cfb:	6a 0c                	push   $0xc
80106cfd:	68 f8 03 00 00       	push   $0x3f8
80106d02:	e8 ae ff ff ff       	call   80106cb5 <outb>
80106d07:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106d0a:	6a 00                	push   $0x0
80106d0c:	68 f9 03 00 00       	push   $0x3f9
80106d11:	e8 9f ff ff ff       	call   80106cb5 <outb>
80106d16:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106d19:	6a 03                	push   $0x3
80106d1b:	68 fb 03 00 00       	push   $0x3fb
80106d20:	e8 90 ff ff ff       	call   80106cb5 <outb>
80106d25:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106d28:	6a 00                	push   $0x0
80106d2a:	68 fc 03 00 00       	push   $0x3fc
80106d2f:	e8 81 ff ff ff       	call   80106cb5 <outb>
80106d34:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106d37:	6a 01                	push   $0x1
80106d39:	68 f9 03 00 00       	push   $0x3f9
80106d3e:	e8 72 ff ff ff       	call   80106cb5 <outb>
80106d43:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106d46:	68 fd 03 00 00       	push   $0x3fd
80106d4b:	e8 48 ff ff ff       	call   80106c98 <inb>
80106d50:	83 c4 04             	add    $0x4,%esp
80106d53:	3c ff                	cmp    $0xff,%al
80106d55:	74 6e                	je     80106dc5 <uartinit+0xf1>
    return;
  uart = 1;
80106d57:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80106d5e:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106d61:	68 fa 03 00 00       	push   $0x3fa
80106d66:	e8 2d ff ff ff       	call   80106c98 <inb>
80106d6b:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106d6e:	68 f8 03 00 00       	push   $0x3f8
80106d73:	e8 20 ff ff ff       	call   80106c98 <inb>
80106d78:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106d7b:	83 ec 0c             	sub    $0xc,%esp
80106d7e:	6a 04                	push   $0x4
80106d80:	e8 75 d2 ff ff       	call   80103ffa <picenable>
80106d85:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106d88:	83 ec 08             	sub    $0x8,%esp
80106d8b:	6a 00                	push   $0x0
80106d8d:	6a 04                	push   $0x4
80106d8f:	e8 c2 bd ff ff       	call   80102b56 <ioapicenable>
80106d94:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106d97:	c7 45 f4 7c 8f 10 80 	movl   $0x80108f7c,-0xc(%ebp)
80106d9e:	eb 19                	jmp    80106db9 <uartinit+0xe5>
    uartputc(*p);
80106da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106da3:	0f b6 00             	movzbl (%eax),%eax
80106da6:	0f be c0             	movsbl %al,%eax
80106da9:	83 ec 0c             	sub    $0xc,%esp
80106dac:	50                   	push   %eax
80106dad:	e8 16 00 00 00       	call   80106dc8 <uartputc>
80106db2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106db5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dbc:	0f b6 00             	movzbl (%eax),%eax
80106dbf:	84 c0                	test   %al,%al
80106dc1:	75 dd                	jne    80106da0 <uartinit+0xcc>
80106dc3:	eb 01                	jmp    80106dc6 <uartinit+0xf2>
    return;
80106dc5:	90                   	nop
}
80106dc6:	c9                   	leave  
80106dc7:	c3                   	ret    

80106dc8 <uartputc>:

void
uartputc(int c)
{
80106dc8:	55                   	push   %ebp
80106dc9:	89 e5                	mov    %esp,%ebp
80106dcb:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106dce:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80106dd3:	85 c0                	test   %eax,%eax
80106dd5:	74 53                	je     80106e2a <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106dd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106dde:	eb 11                	jmp    80106df1 <uartputc+0x29>
    microdelay(10);
80106de0:	83 ec 0c             	sub    $0xc,%esp
80106de3:	6a 0a                	push   $0xa
80106de5:	e8 d2 c2 ff ff       	call   801030bc <microdelay>
80106dea:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ded:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106df1:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106df5:	7f 1a                	jg     80106e11 <uartputc+0x49>
80106df7:	83 ec 0c             	sub    $0xc,%esp
80106dfa:	68 fd 03 00 00       	push   $0x3fd
80106dff:	e8 94 fe ff ff       	call   80106c98 <inb>
80106e04:	83 c4 10             	add    $0x10,%esp
80106e07:	0f b6 c0             	movzbl %al,%eax
80106e0a:	83 e0 20             	and    $0x20,%eax
80106e0d:	85 c0                	test   %eax,%eax
80106e0f:	74 cf                	je     80106de0 <uartputc+0x18>
  outb(COM1+0, c);
80106e11:	8b 45 08             	mov    0x8(%ebp),%eax
80106e14:	0f b6 c0             	movzbl %al,%eax
80106e17:	83 ec 08             	sub    $0x8,%esp
80106e1a:	50                   	push   %eax
80106e1b:	68 f8 03 00 00       	push   $0x3f8
80106e20:	e8 90 fe ff ff       	call   80106cb5 <outb>
80106e25:	83 c4 10             	add    $0x10,%esp
80106e28:	eb 01                	jmp    80106e2b <uartputc+0x63>
    return;
80106e2a:	90                   	nop
}
80106e2b:	c9                   	leave  
80106e2c:	c3                   	ret    

80106e2d <uartgetc>:

static int
uartgetc(void)
{
80106e2d:	55                   	push   %ebp
80106e2e:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106e30:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80106e35:	85 c0                	test   %eax,%eax
80106e37:	75 07                	jne    80106e40 <uartgetc+0x13>
    return -1;
80106e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e3e:	eb 2e                	jmp    80106e6e <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106e40:	68 fd 03 00 00       	push   $0x3fd
80106e45:	e8 4e fe ff ff       	call   80106c98 <inb>
80106e4a:	83 c4 04             	add    $0x4,%esp
80106e4d:	0f b6 c0             	movzbl %al,%eax
80106e50:	83 e0 01             	and    $0x1,%eax
80106e53:	85 c0                	test   %eax,%eax
80106e55:	75 07                	jne    80106e5e <uartgetc+0x31>
    return -1;
80106e57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e5c:	eb 10                	jmp    80106e6e <uartgetc+0x41>
  return inb(COM1+0);
80106e5e:	68 f8 03 00 00       	push   $0x3f8
80106e63:	e8 30 fe ff ff       	call   80106c98 <inb>
80106e68:	83 c4 04             	add    $0x4,%esp
80106e6b:	0f b6 c0             	movzbl %al,%eax
}
80106e6e:	c9                   	leave  
80106e6f:	c3                   	ret    

80106e70 <uartintr>:

void
uartintr(void)
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106e76:	83 ec 0c             	sub    $0xc,%esp
80106e79:	68 2d 6e 10 80       	push   $0x80106e2d
80106e7e:	e8 f2 99 ff ff       	call   80100875 <consoleintr>
80106e83:	83 c4 10             	add    $0x10,%esp
}
80106e86:	90                   	nop
80106e87:	c9                   	leave  
80106e88:	c3                   	ret    

80106e89 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $0
80106e8b:	6a 00                	push   $0x0
  jmp alltraps
80106e8d:	e9 a6 f9 ff ff       	jmp    80106838 <alltraps>

80106e92 <vector1>:
.globl vector1
vector1:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $1
80106e94:	6a 01                	push   $0x1
  jmp alltraps
80106e96:	e9 9d f9 ff ff       	jmp    80106838 <alltraps>

80106e9b <vector2>:
.globl vector2
vector2:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $2
80106e9d:	6a 02                	push   $0x2
  jmp alltraps
80106e9f:	e9 94 f9 ff ff       	jmp    80106838 <alltraps>

80106ea4 <vector3>:
.globl vector3
vector3:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $3
80106ea6:	6a 03                	push   $0x3
  jmp alltraps
80106ea8:	e9 8b f9 ff ff       	jmp    80106838 <alltraps>

80106ead <vector4>:
.globl vector4
vector4:
  pushl $0
80106ead:	6a 00                	push   $0x0
  pushl $4
80106eaf:	6a 04                	push   $0x4
  jmp alltraps
80106eb1:	e9 82 f9 ff ff       	jmp    80106838 <alltraps>

80106eb6 <vector5>:
.globl vector5
vector5:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $5
80106eb8:	6a 05                	push   $0x5
  jmp alltraps
80106eba:	e9 79 f9 ff ff       	jmp    80106838 <alltraps>

80106ebf <vector6>:
.globl vector6
vector6:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $6
80106ec1:	6a 06                	push   $0x6
  jmp alltraps
80106ec3:	e9 70 f9 ff ff       	jmp    80106838 <alltraps>

80106ec8 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ec8:	6a 00                	push   $0x0
  pushl $7
80106eca:	6a 07                	push   $0x7
  jmp alltraps
80106ecc:	e9 67 f9 ff ff       	jmp    80106838 <alltraps>

80106ed1 <vector8>:
.globl vector8
vector8:
  pushl $8
80106ed1:	6a 08                	push   $0x8
  jmp alltraps
80106ed3:	e9 60 f9 ff ff       	jmp    80106838 <alltraps>

80106ed8 <vector9>:
.globl vector9
vector9:
  pushl $0
80106ed8:	6a 00                	push   $0x0
  pushl $9
80106eda:	6a 09                	push   $0x9
  jmp alltraps
80106edc:	e9 57 f9 ff ff       	jmp    80106838 <alltraps>

80106ee1 <vector10>:
.globl vector10
vector10:
  pushl $10
80106ee1:	6a 0a                	push   $0xa
  jmp alltraps
80106ee3:	e9 50 f9 ff ff       	jmp    80106838 <alltraps>

80106ee8 <vector11>:
.globl vector11
vector11:
  pushl $11
80106ee8:	6a 0b                	push   $0xb
  jmp alltraps
80106eea:	e9 49 f9 ff ff       	jmp    80106838 <alltraps>

80106eef <vector12>:
.globl vector12
vector12:
  pushl $12
80106eef:	6a 0c                	push   $0xc
  jmp alltraps
80106ef1:	e9 42 f9 ff ff       	jmp    80106838 <alltraps>

80106ef6 <vector13>:
.globl vector13
vector13:
  pushl $13
80106ef6:	6a 0d                	push   $0xd
  jmp alltraps
80106ef8:	e9 3b f9 ff ff       	jmp    80106838 <alltraps>

80106efd <vector14>:
.globl vector14
vector14:
  pushl $14
80106efd:	6a 0e                	push   $0xe
  jmp alltraps
80106eff:	e9 34 f9 ff ff       	jmp    80106838 <alltraps>

80106f04 <vector15>:
.globl vector15
vector15:
  pushl $0
80106f04:	6a 00                	push   $0x0
  pushl $15
80106f06:	6a 0f                	push   $0xf
  jmp alltraps
80106f08:	e9 2b f9 ff ff       	jmp    80106838 <alltraps>

80106f0d <vector16>:
.globl vector16
vector16:
  pushl $0
80106f0d:	6a 00                	push   $0x0
  pushl $16
80106f0f:	6a 10                	push   $0x10
  jmp alltraps
80106f11:	e9 22 f9 ff ff       	jmp    80106838 <alltraps>

80106f16 <vector17>:
.globl vector17
vector17:
  pushl $17
80106f16:	6a 11                	push   $0x11
  jmp alltraps
80106f18:	e9 1b f9 ff ff       	jmp    80106838 <alltraps>

80106f1d <vector18>:
.globl vector18
vector18:
  pushl $0
80106f1d:	6a 00                	push   $0x0
  pushl $18
80106f1f:	6a 12                	push   $0x12
  jmp alltraps
80106f21:	e9 12 f9 ff ff       	jmp    80106838 <alltraps>

80106f26 <vector19>:
.globl vector19
vector19:
  pushl $0
80106f26:	6a 00                	push   $0x0
  pushl $19
80106f28:	6a 13                	push   $0x13
  jmp alltraps
80106f2a:	e9 09 f9 ff ff       	jmp    80106838 <alltraps>

80106f2f <vector20>:
.globl vector20
vector20:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $20
80106f31:	6a 14                	push   $0x14
  jmp alltraps
80106f33:	e9 00 f9 ff ff       	jmp    80106838 <alltraps>

80106f38 <vector21>:
.globl vector21
vector21:
  pushl $0
80106f38:	6a 00                	push   $0x0
  pushl $21
80106f3a:	6a 15                	push   $0x15
  jmp alltraps
80106f3c:	e9 f7 f8 ff ff       	jmp    80106838 <alltraps>

80106f41 <vector22>:
.globl vector22
vector22:
  pushl $0
80106f41:	6a 00                	push   $0x0
  pushl $22
80106f43:	6a 16                	push   $0x16
  jmp alltraps
80106f45:	e9 ee f8 ff ff       	jmp    80106838 <alltraps>

80106f4a <vector23>:
.globl vector23
vector23:
  pushl $0
80106f4a:	6a 00                	push   $0x0
  pushl $23
80106f4c:	6a 17                	push   $0x17
  jmp alltraps
80106f4e:	e9 e5 f8 ff ff       	jmp    80106838 <alltraps>

80106f53 <vector24>:
.globl vector24
vector24:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $24
80106f55:	6a 18                	push   $0x18
  jmp alltraps
80106f57:	e9 dc f8 ff ff       	jmp    80106838 <alltraps>

80106f5c <vector25>:
.globl vector25
vector25:
  pushl $0
80106f5c:	6a 00                	push   $0x0
  pushl $25
80106f5e:	6a 19                	push   $0x19
  jmp alltraps
80106f60:	e9 d3 f8 ff ff       	jmp    80106838 <alltraps>

80106f65 <vector26>:
.globl vector26
vector26:
  pushl $0
80106f65:	6a 00                	push   $0x0
  pushl $26
80106f67:	6a 1a                	push   $0x1a
  jmp alltraps
80106f69:	e9 ca f8 ff ff       	jmp    80106838 <alltraps>

80106f6e <vector27>:
.globl vector27
vector27:
  pushl $0
80106f6e:	6a 00                	push   $0x0
  pushl $27
80106f70:	6a 1b                	push   $0x1b
  jmp alltraps
80106f72:	e9 c1 f8 ff ff       	jmp    80106838 <alltraps>

80106f77 <vector28>:
.globl vector28
vector28:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $28
80106f79:	6a 1c                	push   $0x1c
  jmp alltraps
80106f7b:	e9 b8 f8 ff ff       	jmp    80106838 <alltraps>

80106f80 <vector29>:
.globl vector29
vector29:
  pushl $0
80106f80:	6a 00                	push   $0x0
  pushl $29
80106f82:	6a 1d                	push   $0x1d
  jmp alltraps
80106f84:	e9 af f8 ff ff       	jmp    80106838 <alltraps>

80106f89 <vector30>:
.globl vector30
vector30:
  pushl $0
80106f89:	6a 00                	push   $0x0
  pushl $30
80106f8b:	6a 1e                	push   $0x1e
  jmp alltraps
80106f8d:	e9 a6 f8 ff ff       	jmp    80106838 <alltraps>

80106f92 <vector31>:
.globl vector31
vector31:
  pushl $0
80106f92:	6a 00                	push   $0x0
  pushl $31
80106f94:	6a 1f                	push   $0x1f
  jmp alltraps
80106f96:	e9 9d f8 ff ff       	jmp    80106838 <alltraps>

80106f9b <vector32>:
.globl vector32
vector32:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $32
80106f9d:	6a 20                	push   $0x20
  jmp alltraps
80106f9f:	e9 94 f8 ff ff       	jmp    80106838 <alltraps>

80106fa4 <vector33>:
.globl vector33
vector33:
  pushl $0
80106fa4:	6a 00                	push   $0x0
  pushl $33
80106fa6:	6a 21                	push   $0x21
  jmp alltraps
80106fa8:	e9 8b f8 ff ff       	jmp    80106838 <alltraps>

80106fad <vector34>:
.globl vector34
vector34:
  pushl $0
80106fad:	6a 00                	push   $0x0
  pushl $34
80106faf:	6a 22                	push   $0x22
  jmp alltraps
80106fb1:	e9 82 f8 ff ff       	jmp    80106838 <alltraps>

80106fb6 <vector35>:
.globl vector35
vector35:
  pushl $0
80106fb6:	6a 00                	push   $0x0
  pushl $35
80106fb8:	6a 23                	push   $0x23
  jmp alltraps
80106fba:	e9 79 f8 ff ff       	jmp    80106838 <alltraps>

80106fbf <vector36>:
.globl vector36
vector36:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $36
80106fc1:	6a 24                	push   $0x24
  jmp alltraps
80106fc3:	e9 70 f8 ff ff       	jmp    80106838 <alltraps>

80106fc8 <vector37>:
.globl vector37
vector37:
  pushl $0
80106fc8:	6a 00                	push   $0x0
  pushl $37
80106fca:	6a 25                	push   $0x25
  jmp alltraps
80106fcc:	e9 67 f8 ff ff       	jmp    80106838 <alltraps>

80106fd1 <vector38>:
.globl vector38
vector38:
  pushl $0
80106fd1:	6a 00                	push   $0x0
  pushl $38
80106fd3:	6a 26                	push   $0x26
  jmp alltraps
80106fd5:	e9 5e f8 ff ff       	jmp    80106838 <alltraps>

80106fda <vector39>:
.globl vector39
vector39:
  pushl $0
80106fda:	6a 00                	push   $0x0
  pushl $39
80106fdc:	6a 27                	push   $0x27
  jmp alltraps
80106fde:	e9 55 f8 ff ff       	jmp    80106838 <alltraps>

80106fe3 <vector40>:
.globl vector40
vector40:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $40
80106fe5:	6a 28                	push   $0x28
  jmp alltraps
80106fe7:	e9 4c f8 ff ff       	jmp    80106838 <alltraps>

80106fec <vector41>:
.globl vector41
vector41:
  pushl $0
80106fec:	6a 00                	push   $0x0
  pushl $41
80106fee:	6a 29                	push   $0x29
  jmp alltraps
80106ff0:	e9 43 f8 ff ff       	jmp    80106838 <alltraps>

80106ff5 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ff5:	6a 00                	push   $0x0
  pushl $42
80106ff7:	6a 2a                	push   $0x2a
  jmp alltraps
80106ff9:	e9 3a f8 ff ff       	jmp    80106838 <alltraps>

80106ffe <vector43>:
.globl vector43
vector43:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $43
80107000:	6a 2b                	push   $0x2b
  jmp alltraps
80107002:	e9 31 f8 ff ff       	jmp    80106838 <alltraps>

80107007 <vector44>:
.globl vector44
vector44:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $44
80107009:	6a 2c                	push   $0x2c
  jmp alltraps
8010700b:	e9 28 f8 ff ff       	jmp    80106838 <alltraps>

80107010 <vector45>:
.globl vector45
vector45:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $45
80107012:	6a 2d                	push   $0x2d
  jmp alltraps
80107014:	e9 1f f8 ff ff       	jmp    80106838 <alltraps>

80107019 <vector46>:
.globl vector46
vector46:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $46
8010701b:	6a 2e                	push   $0x2e
  jmp alltraps
8010701d:	e9 16 f8 ff ff       	jmp    80106838 <alltraps>

80107022 <vector47>:
.globl vector47
vector47:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $47
80107024:	6a 2f                	push   $0x2f
  jmp alltraps
80107026:	e9 0d f8 ff ff       	jmp    80106838 <alltraps>

8010702b <vector48>:
.globl vector48
vector48:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $48
8010702d:	6a 30                	push   $0x30
  jmp alltraps
8010702f:	e9 04 f8 ff ff       	jmp    80106838 <alltraps>

80107034 <vector49>:
.globl vector49
vector49:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $49
80107036:	6a 31                	push   $0x31
  jmp alltraps
80107038:	e9 fb f7 ff ff       	jmp    80106838 <alltraps>

8010703d <vector50>:
.globl vector50
vector50:
  pushl $0
8010703d:	6a 00                	push   $0x0
  pushl $50
8010703f:	6a 32                	push   $0x32
  jmp alltraps
80107041:	e9 f2 f7 ff ff       	jmp    80106838 <alltraps>

80107046 <vector51>:
.globl vector51
vector51:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $51
80107048:	6a 33                	push   $0x33
  jmp alltraps
8010704a:	e9 e9 f7 ff ff       	jmp    80106838 <alltraps>

8010704f <vector52>:
.globl vector52
vector52:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $52
80107051:	6a 34                	push   $0x34
  jmp alltraps
80107053:	e9 e0 f7 ff ff       	jmp    80106838 <alltraps>

80107058 <vector53>:
.globl vector53
vector53:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $53
8010705a:	6a 35                	push   $0x35
  jmp alltraps
8010705c:	e9 d7 f7 ff ff       	jmp    80106838 <alltraps>

80107061 <vector54>:
.globl vector54
vector54:
  pushl $0
80107061:	6a 00                	push   $0x0
  pushl $54
80107063:	6a 36                	push   $0x36
  jmp alltraps
80107065:	e9 ce f7 ff ff       	jmp    80106838 <alltraps>

8010706a <vector55>:
.globl vector55
vector55:
  pushl $0
8010706a:	6a 00                	push   $0x0
  pushl $55
8010706c:	6a 37                	push   $0x37
  jmp alltraps
8010706e:	e9 c5 f7 ff ff       	jmp    80106838 <alltraps>

80107073 <vector56>:
.globl vector56
vector56:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $56
80107075:	6a 38                	push   $0x38
  jmp alltraps
80107077:	e9 bc f7 ff ff       	jmp    80106838 <alltraps>

8010707c <vector57>:
.globl vector57
vector57:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $57
8010707e:	6a 39                	push   $0x39
  jmp alltraps
80107080:	e9 b3 f7 ff ff       	jmp    80106838 <alltraps>

80107085 <vector58>:
.globl vector58
vector58:
  pushl $0
80107085:	6a 00                	push   $0x0
  pushl $58
80107087:	6a 3a                	push   $0x3a
  jmp alltraps
80107089:	e9 aa f7 ff ff       	jmp    80106838 <alltraps>

8010708e <vector59>:
.globl vector59
vector59:
  pushl $0
8010708e:	6a 00                	push   $0x0
  pushl $59
80107090:	6a 3b                	push   $0x3b
  jmp alltraps
80107092:	e9 a1 f7 ff ff       	jmp    80106838 <alltraps>

80107097 <vector60>:
.globl vector60
vector60:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $60
80107099:	6a 3c                	push   $0x3c
  jmp alltraps
8010709b:	e9 98 f7 ff ff       	jmp    80106838 <alltraps>

801070a0 <vector61>:
.globl vector61
vector61:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $61
801070a2:	6a 3d                	push   $0x3d
  jmp alltraps
801070a4:	e9 8f f7 ff ff       	jmp    80106838 <alltraps>

801070a9 <vector62>:
.globl vector62
vector62:
  pushl $0
801070a9:	6a 00                	push   $0x0
  pushl $62
801070ab:	6a 3e                	push   $0x3e
  jmp alltraps
801070ad:	e9 86 f7 ff ff       	jmp    80106838 <alltraps>

801070b2 <vector63>:
.globl vector63
vector63:
  pushl $0
801070b2:	6a 00                	push   $0x0
  pushl $63
801070b4:	6a 3f                	push   $0x3f
  jmp alltraps
801070b6:	e9 7d f7 ff ff       	jmp    80106838 <alltraps>

801070bb <vector64>:
.globl vector64
vector64:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $64
801070bd:	6a 40                	push   $0x40
  jmp alltraps
801070bf:	e9 74 f7 ff ff       	jmp    80106838 <alltraps>

801070c4 <vector65>:
.globl vector65
vector65:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $65
801070c6:	6a 41                	push   $0x41
  jmp alltraps
801070c8:	e9 6b f7 ff ff       	jmp    80106838 <alltraps>

801070cd <vector66>:
.globl vector66
vector66:
  pushl $0
801070cd:	6a 00                	push   $0x0
  pushl $66
801070cf:	6a 42                	push   $0x42
  jmp alltraps
801070d1:	e9 62 f7 ff ff       	jmp    80106838 <alltraps>

801070d6 <vector67>:
.globl vector67
vector67:
  pushl $0
801070d6:	6a 00                	push   $0x0
  pushl $67
801070d8:	6a 43                	push   $0x43
  jmp alltraps
801070da:	e9 59 f7 ff ff       	jmp    80106838 <alltraps>

801070df <vector68>:
.globl vector68
vector68:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $68
801070e1:	6a 44                	push   $0x44
  jmp alltraps
801070e3:	e9 50 f7 ff ff       	jmp    80106838 <alltraps>

801070e8 <vector69>:
.globl vector69
vector69:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $69
801070ea:	6a 45                	push   $0x45
  jmp alltraps
801070ec:	e9 47 f7 ff ff       	jmp    80106838 <alltraps>

801070f1 <vector70>:
.globl vector70
vector70:
  pushl $0
801070f1:	6a 00                	push   $0x0
  pushl $70
801070f3:	6a 46                	push   $0x46
  jmp alltraps
801070f5:	e9 3e f7 ff ff       	jmp    80106838 <alltraps>

801070fa <vector71>:
.globl vector71
vector71:
  pushl $0
801070fa:	6a 00                	push   $0x0
  pushl $71
801070fc:	6a 47                	push   $0x47
  jmp alltraps
801070fe:	e9 35 f7 ff ff       	jmp    80106838 <alltraps>

80107103 <vector72>:
.globl vector72
vector72:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $72
80107105:	6a 48                	push   $0x48
  jmp alltraps
80107107:	e9 2c f7 ff ff       	jmp    80106838 <alltraps>

8010710c <vector73>:
.globl vector73
vector73:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $73
8010710e:	6a 49                	push   $0x49
  jmp alltraps
80107110:	e9 23 f7 ff ff       	jmp    80106838 <alltraps>

80107115 <vector74>:
.globl vector74
vector74:
  pushl $0
80107115:	6a 00                	push   $0x0
  pushl $74
80107117:	6a 4a                	push   $0x4a
  jmp alltraps
80107119:	e9 1a f7 ff ff       	jmp    80106838 <alltraps>

8010711e <vector75>:
.globl vector75
vector75:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $75
80107120:	6a 4b                	push   $0x4b
  jmp alltraps
80107122:	e9 11 f7 ff ff       	jmp    80106838 <alltraps>

80107127 <vector76>:
.globl vector76
vector76:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $76
80107129:	6a 4c                	push   $0x4c
  jmp alltraps
8010712b:	e9 08 f7 ff ff       	jmp    80106838 <alltraps>

80107130 <vector77>:
.globl vector77
vector77:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $77
80107132:	6a 4d                	push   $0x4d
  jmp alltraps
80107134:	e9 ff f6 ff ff       	jmp    80106838 <alltraps>

80107139 <vector78>:
.globl vector78
vector78:
  pushl $0
80107139:	6a 00                	push   $0x0
  pushl $78
8010713b:	6a 4e                	push   $0x4e
  jmp alltraps
8010713d:	e9 f6 f6 ff ff       	jmp    80106838 <alltraps>

80107142 <vector79>:
.globl vector79
vector79:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $79
80107144:	6a 4f                	push   $0x4f
  jmp alltraps
80107146:	e9 ed f6 ff ff       	jmp    80106838 <alltraps>

8010714b <vector80>:
.globl vector80
vector80:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $80
8010714d:	6a 50                	push   $0x50
  jmp alltraps
8010714f:	e9 e4 f6 ff ff       	jmp    80106838 <alltraps>

80107154 <vector81>:
.globl vector81
vector81:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $81
80107156:	6a 51                	push   $0x51
  jmp alltraps
80107158:	e9 db f6 ff ff       	jmp    80106838 <alltraps>

8010715d <vector82>:
.globl vector82
vector82:
  pushl $0
8010715d:	6a 00                	push   $0x0
  pushl $82
8010715f:	6a 52                	push   $0x52
  jmp alltraps
80107161:	e9 d2 f6 ff ff       	jmp    80106838 <alltraps>

80107166 <vector83>:
.globl vector83
vector83:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $83
80107168:	6a 53                	push   $0x53
  jmp alltraps
8010716a:	e9 c9 f6 ff ff       	jmp    80106838 <alltraps>

8010716f <vector84>:
.globl vector84
vector84:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $84
80107171:	6a 54                	push   $0x54
  jmp alltraps
80107173:	e9 c0 f6 ff ff       	jmp    80106838 <alltraps>

80107178 <vector85>:
.globl vector85
vector85:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $85
8010717a:	6a 55                	push   $0x55
  jmp alltraps
8010717c:	e9 b7 f6 ff ff       	jmp    80106838 <alltraps>

80107181 <vector86>:
.globl vector86
vector86:
  pushl $0
80107181:	6a 00                	push   $0x0
  pushl $86
80107183:	6a 56                	push   $0x56
  jmp alltraps
80107185:	e9 ae f6 ff ff       	jmp    80106838 <alltraps>

8010718a <vector87>:
.globl vector87
vector87:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $87
8010718c:	6a 57                	push   $0x57
  jmp alltraps
8010718e:	e9 a5 f6 ff ff       	jmp    80106838 <alltraps>

80107193 <vector88>:
.globl vector88
vector88:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $88
80107195:	6a 58                	push   $0x58
  jmp alltraps
80107197:	e9 9c f6 ff ff       	jmp    80106838 <alltraps>

8010719c <vector89>:
.globl vector89
vector89:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $89
8010719e:	6a 59                	push   $0x59
  jmp alltraps
801071a0:	e9 93 f6 ff ff       	jmp    80106838 <alltraps>

801071a5 <vector90>:
.globl vector90
vector90:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $90
801071a7:	6a 5a                	push   $0x5a
  jmp alltraps
801071a9:	e9 8a f6 ff ff       	jmp    80106838 <alltraps>

801071ae <vector91>:
.globl vector91
vector91:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $91
801071b0:	6a 5b                	push   $0x5b
  jmp alltraps
801071b2:	e9 81 f6 ff ff       	jmp    80106838 <alltraps>

801071b7 <vector92>:
.globl vector92
vector92:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $92
801071b9:	6a 5c                	push   $0x5c
  jmp alltraps
801071bb:	e9 78 f6 ff ff       	jmp    80106838 <alltraps>

801071c0 <vector93>:
.globl vector93
vector93:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $93
801071c2:	6a 5d                	push   $0x5d
  jmp alltraps
801071c4:	e9 6f f6 ff ff       	jmp    80106838 <alltraps>

801071c9 <vector94>:
.globl vector94
vector94:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $94
801071cb:	6a 5e                	push   $0x5e
  jmp alltraps
801071cd:	e9 66 f6 ff ff       	jmp    80106838 <alltraps>

801071d2 <vector95>:
.globl vector95
vector95:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $95
801071d4:	6a 5f                	push   $0x5f
  jmp alltraps
801071d6:	e9 5d f6 ff ff       	jmp    80106838 <alltraps>

801071db <vector96>:
.globl vector96
vector96:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $96
801071dd:	6a 60                	push   $0x60
  jmp alltraps
801071df:	e9 54 f6 ff ff       	jmp    80106838 <alltraps>

801071e4 <vector97>:
.globl vector97
vector97:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $97
801071e6:	6a 61                	push   $0x61
  jmp alltraps
801071e8:	e9 4b f6 ff ff       	jmp    80106838 <alltraps>

801071ed <vector98>:
.globl vector98
vector98:
  pushl $0
801071ed:	6a 00                	push   $0x0
  pushl $98
801071ef:	6a 62                	push   $0x62
  jmp alltraps
801071f1:	e9 42 f6 ff ff       	jmp    80106838 <alltraps>

801071f6 <vector99>:
.globl vector99
vector99:
  pushl $0
801071f6:	6a 00                	push   $0x0
  pushl $99
801071f8:	6a 63                	push   $0x63
  jmp alltraps
801071fa:	e9 39 f6 ff ff       	jmp    80106838 <alltraps>

801071ff <vector100>:
.globl vector100
vector100:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $100
80107201:	6a 64                	push   $0x64
  jmp alltraps
80107203:	e9 30 f6 ff ff       	jmp    80106838 <alltraps>

80107208 <vector101>:
.globl vector101
vector101:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $101
8010720a:	6a 65                	push   $0x65
  jmp alltraps
8010720c:	e9 27 f6 ff ff       	jmp    80106838 <alltraps>

80107211 <vector102>:
.globl vector102
vector102:
  pushl $0
80107211:	6a 00                	push   $0x0
  pushl $102
80107213:	6a 66                	push   $0x66
  jmp alltraps
80107215:	e9 1e f6 ff ff       	jmp    80106838 <alltraps>

8010721a <vector103>:
.globl vector103
vector103:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $103
8010721c:	6a 67                	push   $0x67
  jmp alltraps
8010721e:	e9 15 f6 ff ff       	jmp    80106838 <alltraps>

80107223 <vector104>:
.globl vector104
vector104:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $104
80107225:	6a 68                	push   $0x68
  jmp alltraps
80107227:	e9 0c f6 ff ff       	jmp    80106838 <alltraps>

8010722c <vector105>:
.globl vector105
vector105:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $105
8010722e:	6a 69                	push   $0x69
  jmp alltraps
80107230:	e9 03 f6 ff ff       	jmp    80106838 <alltraps>

80107235 <vector106>:
.globl vector106
vector106:
  pushl $0
80107235:	6a 00                	push   $0x0
  pushl $106
80107237:	6a 6a                	push   $0x6a
  jmp alltraps
80107239:	e9 fa f5 ff ff       	jmp    80106838 <alltraps>

8010723e <vector107>:
.globl vector107
vector107:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $107
80107240:	6a 6b                	push   $0x6b
  jmp alltraps
80107242:	e9 f1 f5 ff ff       	jmp    80106838 <alltraps>

80107247 <vector108>:
.globl vector108
vector108:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $108
80107249:	6a 6c                	push   $0x6c
  jmp alltraps
8010724b:	e9 e8 f5 ff ff       	jmp    80106838 <alltraps>

80107250 <vector109>:
.globl vector109
vector109:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $109
80107252:	6a 6d                	push   $0x6d
  jmp alltraps
80107254:	e9 df f5 ff ff       	jmp    80106838 <alltraps>

80107259 <vector110>:
.globl vector110
vector110:
  pushl $0
80107259:	6a 00                	push   $0x0
  pushl $110
8010725b:	6a 6e                	push   $0x6e
  jmp alltraps
8010725d:	e9 d6 f5 ff ff       	jmp    80106838 <alltraps>

80107262 <vector111>:
.globl vector111
vector111:
  pushl $0
80107262:	6a 00                	push   $0x0
  pushl $111
80107264:	6a 6f                	push   $0x6f
  jmp alltraps
80107266:	e9 cd f5 ff ff       	jmp    80106838 <alltraps>

8010726b <vector112>:
.globl vector112
vector112:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $112
8010726d:	6a 70                	push   $0x70
  jmp alltraps
8010726f:	e9 c4 f5 ff ff       	jmp    80106838 <alltraps>

80107274 <vector113>:
.globl vector113
vector113:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $113
80107276:	6a 71                	push   $0x71
  jmp alltraps
80107278:	e9 bb f5 ff ff       	jmp    80106838 <alltraps>

8010727d <vector114>:
.globl vector114
vector114:
  pushl $0
8010727d:	6a 00                	push   $0x0
  pushl $114
8010727f:	6a 72                	push   $0x72
  jmp alltraps
80107281:	e9 b2 f5 ff ff       	jmp    80106838 <alltraps>

80107286 <vector115>:
.globl vector115
vector115:
  pushl $0
80107286:	6a 00                	push   $0x0
  pushl $115
80107288:	6a 73                	push   $0x73
  jmp alltraps
8010728a:	e9 a9 f5 ff ff       	jmp    80106838 <alltraps>

8010728f <vector116>:
.globl vector116
vector116:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $116
80107291:	6a 74                	push   $0x74
  jmp alltraps
80107293:	e9 a0 f5 ff ff       	jmp    80106838 <alltraps>

80107298 <vector117>:
.globl vector117
vector117:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $117
8010729a:	6a 75                	push   $0x75
  jmp alltraps
8010729c:	e9 97 f5 ff ff       	jmp    80106838 <alltraps>

801072a1 <vector118>:
.globl vector118
vector118:
  pushl $0
801072a1:	6a 00                	push   $0x0
  pushl $118
801072a3:	6a 76                	push   $0x76
  jmp alltraps
801072a5:	e9 8e f5 ff ff       	jmp    80106838 <alltraps>

801072aa <vector119>:
.globl vector119
vector119:
  pushl $0
801072aa:	6a 00                	push   $0x0
  pushl $119
801072ac:	6a 77                	push   $0x77
  jmp alltraps
801072ae:	e9 85 f5 ff ff       	jmp    80106838 <alltraps>

801072b3 <vector120>:
.globl vector120
vector120:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $120
801072b5:	6a 78                	push   $0x78
  jmp alltraps
801072b7:	e9 7c f5 ff ff       	jmp    80106838 <alltraps>

801072bc <vector121>:
.globl vector121
vector121:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $121
801072be:	6a 79                	push   $0x79
  jmp alltraps
801072c0:	e9 73 f5 ff ff       	jmp    80106838 <alltraps>

801072c5 <vector122>:
.globl vector122
vector122:
  pushl $0
801072c5:	6a 00                	push   $0x0
  pushl $122
801072c7:	6a 7a                	push   $0x7a
  jmp alltraps
801072c9:	e9 6a f5 ff ff       	jmp    80106838 <alltraps>

801072ce <vector123>:
.globl vector123
vector123:
  pushl $0
801072ce:	6a 00                	push   $0x0
  pushl $123
801072d0:	6a 7b                	push   $0x7b
  jmp alltraps
801072d2:	e9 61 f5 ff ff       	jmp    80106838 <alltraps>

801072d7 <vector124>:
.globl vector124
vector124:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $124
801072d9:	6a 7c                	push   $0x7c
  jmp alltraps
801072db:	e9 58 f5 ff ff       	jmp    80106838 <alltraps>

801072e0 <vector125>:
.globl vector125
vector125:
  pushl $0
801072e0:	6a 00                	push   $0x0
  pushl $125
801072e2:	6a 7d                	push   $0x7d
  jmp alltraps
801072e4:	e9 4f f5 ff ff       	jmp    80106838 <alltraps>

801072e9 <vector126>:
.globl vector126
vector126:
  pushl $0
801072e9:	6a 00                	push   $0x0
  pushl $126
801072eb:	6a 7e                	push   $0x7e
  jmp alltraps
801072ed:	e9 46 f5 ff ff       	jmp    80106838 <alltraps>

801072f2 <vector127>:
.globl vector127
vector127:
  pushl $0
801072f2:	6a 00                	push   $0x0
  pushl $127
801072f4:	6a 7f                	push   $0x7f
  jmp alltraps
801072f6:	e9 3d f5 ff ff       	jmp    80106838 <alltraps>

801072fb <vector128>:
.globl vector128
vector128:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $128
801072fd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107302:	e9 31 f5 ff ff       	jmp    80106838 <alltraps>

80107307 <vector129>:
.globl vector129
vector129:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $129
80107309:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010730e:	e9 25 f5 ff ff       	jmp    80106838 <alltraps>

80107313 <vector130>:
.globl vector130
vector130:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $130
80107315:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010731a:	e9 19 f5 ff ff       	jmp    80106838 <alltraps>

8010731f <vector131>:
.globl vector131
vector131:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $131
80107321:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107326:	e9 0d f5 ff ff       	jmp    80106838 <alltraps>

8010732b <vector132>:
.globl vector132
vector132:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $132
8010732d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107332:	e9 01 f5 ff ff       	jmp    80106838 <alltraps>

80107337 <vector133>:
.globl vector133
vector133:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $133
80107339:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010733e:	e9 f5 f4 ff ff       	jmp    80106838 <alltraps>

80107343 <vector134>:
.globl vector134
vector134:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $134
80107345:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010734a:	e9 e9 f4 ff ff       	jmp    80106838 <alltraps>

8010734f <vector135>:
.globl vector135
vector135:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $135
80107351:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107356:	e9 dd f4 ff ff       	jmp    80106838 <alltraps>

8010735b <vector136>:
.globl vector136
vector136:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $136
8010735d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107362:	e9 d1 f4 ff ff       	jmp    80106838 <alltraps>

80107367 <vector137>:
.globl vector137
vector137:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $137
80107369:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010736e:	e9 c5 f4 ff ff       	jmp    80106838 <alltraps>

80107373 <vector138>:
.globl vector138
vector138:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $138
80107375:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010737a:	e9 b9 f4 ff ff       	jmp    80106838 <alltraps>

8010737f <vector139>:
.globl vector139
vector139:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $139
80107381:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107386:	e9 ad f4 ff ff       	jmp    80106838 <alltraps>

8010738b <vector140>:
.globl vector140
vector140:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $140
8010738d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107392:	e9 a1 f4 ff ff       	jmp    80106838 <alltraps>

80107397 <vector141>:
.globl vector141
vector141:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $141
80107399:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010739e:	e9 95 f4 ff ff       	jmp    80106838 <alltraps>

801073a3 <vector142>:
.globl vector142
vector142:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $142
801073a5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801073aa:	e9 89 f4 ff ff       	jmp    80106838 <alltraps>

801073af <vector143>:
.globl vector143
vector143:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $143
801073b1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801073b6:	e9 7d f4 ff ff       	jmp    80106838 <alltraps>

801073bb <vector144>:
.globl vector144
vector144:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $144
801073bd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801073c2:	e9 71 f4 ff ff       	jmp    80106838 <alltraps>

801073c7 <vector145>:
.globl vector145
vector145:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $145
801073c9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801073ce:	e9 65 f4 ff ff       	jmp    80106838 <alltraps>

801073d3 <vector146>:
.globl vector146
vector146:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $146
801073d5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801073da:	e9 59 f4 ff ff       	jmp    80106838 <alltraps>

801073df <vector147>:
.globl vector147
vector147:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $147
801073e1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801073e6:	e9 4d f4 ff ff       	jmp    80106838 <alltraps>

801073eb <vector148>:
.globl vector148
vector148:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $148
801073ed:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801073f2:	e9 41 f4 ff ff       	jmp    80106838 <alltraps>

801073f7 <vector149>:
.globl vector149
vector149:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $149
801073f9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801073fe:	e9 35 f4 ff ff       	jmp    80106838 <alltraps>

80107403 <vector150>:
.globl vector150
vector150:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $150
80107405:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010740a:	e9 29 f4 ff ff       	jmp    80106838 <alltraps>

8010740f <vector151>:
.globl vector151
vector151:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $151
80107411:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107416:	e9 1d f4 ff ff       	jmp    80106838 <alltraps>

8010741b <vector152>:
.globl vector152
vector152:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $152
8010741d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107422:	e9 11 f4 ff ff       	jmp    80106838 <alltraps>

80107427 <vector153>:
.globl vector153
vector153:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $153
80107429:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010742e:	e9 05 f4 ff ff       	jmp    80106838 <alltraps>

80107433 <vector154>:
.globl vector154
vector154:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $154
80107435:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010743a:	e9 f9 f3 ff ff       	jmp    80106838 <alltraps>

8010743f <vector155>:
.globl vector155
vector155:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $155
80107441:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107446:	e9 ed f3 ff ff       	jmp    80106838 <alltraps>

8010744b <vector156>:
.globl vector156
vector156:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $156
8010744d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107452:	e9 e1 f3 ff ff       	jmp    80106838 <alltraps>

80107457 <vector157>:
.globl vector157
vector157:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $157
80107459:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010745e:	e9 d5 f3 ff ff       	jmp    80106838 <alltraps>

80107463 <vector158>:
.globl vector158
vector158:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $158
80107465:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010746a:	e9 c9 f3 ff ff       	jmp    80106838 <alltraps>

8010746f <vector159>:
.globl vector159
vector159:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $159
80107471:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107476:	e9 bd f3 ff ff       	jmp    80106838 <alltraps>

8010747b <vector160>:
.globl vector160
vector160:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $160
8010747d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107482:	e9 b1 f3 ff ff       	jmp    80106838 <alltraps>

80107487 <vector161>:
.globl vector161
vector161:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $161
80107489:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010748e:	e9 a5 f3 ff ff       	jmp    80106838 <alltraps>

80107493 <vector162>:
.globl vector162
vector162:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $162
80107495:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010749a:	e9 99 f3 ff ff       	jmp    80106838 <alltraps>

8010749f <vector163>:
.globl vector163
vector163:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $163
801074a1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801074a6:	e9 8d f3 ff ff       	jmp    80106838 <alltraps>

801074ab <vector164>:
.globl vector164
vector164:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $164
801074ad:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801074b2:	e9 81 f3 ff ff       	jmp    80106838 <alltraps>

801074b7 <vector165>:
.globl vector165
vector165:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $165
801074b9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801074be:	e9 75 f3 ff ff       	jmp    80106838 <alltraps>

801074c3 <vector166>:
.globl vector166
vector166:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $166
801074c5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801074ca:	e9 69 f3 ff ff       	jmp    80106838 <alltraps>

801074cf <vector167>:
.globl vector167
vector167:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $167
801074d1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801074d6:	e9 5d f3 ff ff       	jmp    80106838 <alltraps>

801074db <vector168>:
.globl vector168
vector168:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $168
801074dd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801074e2:	e9 51 f3 ff ff       	jmp    80106838 <alltraps>

801074e7 <vector169>:
.globl vector169
vector169:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $169
801074e9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801074ee:	e9 45 f3 ff ff       	jmp    80106838 <alltraps>

801074f3 <vector170>:
.globl vector170
vector170:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $170
801074f5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801074fa:	e9 39 f3 ff ff       	jmp    80106838 <alltraps>

801074ff <vector171>:
.globl vector171
vector171:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $171
80107501:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107506:	e9 2d f3 ff ff       	jmp    80106838 <alltraps>

8010750b <vector172>:
.globl vector172
vector172:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $172
8010750d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107512:	e9 21 f3 ff ff       	jmp    80106838 <alltraps>

80107517 <vector173>:
.globl vector173
vector173:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $173
80107519:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010751e:	e9 15 f3 ff ff       	jmp    80106838 <alltraps>

80107523 <vector174>:
.globl vector174
vector174:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $174
80107525:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010752a:	e9 09 f3 ff ff       	jmp    80106838 <alltraps>

8010752f <vector175>:
.globl vector175
vector175:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $175
80107531:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107536:	e9 fd f2 ff ff       	jmp    80106838 <alltraps>

8010753b <vector176>:
.globl vector176
vector176:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $176
8010753d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107542:	e9 f1 f2 ff ff       	jmp    80106838 <alltraps>

80107547 <vector177>:
.globl vector177
vector177:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $177
80107549:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010754e:	e9 e5 f2 ff ff       	jmp    80106838 <alltraps>

80107553 <vector178>:
.globl vector178
vector178:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $178
80107555:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010755a:	e9 d9 f2 ff ff       	jmp    80106838 <alltraps>

8010755f <vector179>:
.globl vector179
vector179:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $179
80107561:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107566:	e9 cd f2 ff ff       	jmp    80106838 <alltraps>

8010756b <vector180>:
.globl vector180
vector180:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $180
8010756d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107572:	e9 c1 f2 ff ff       	jmp    80106838 <alltraps>

80107577 <vector181>:
.globl vector181
vector181:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $181
80107579:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010757e:	e9 b5 f2 ff ff       	jmp    80106838 <alltraps>

80107583 <vector182>:
.globl vector182
vector182:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $182
80107585:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010758a:	e9 a9 f2 ff ff       	jmp    80106838 <alltraps>

8010758f <vector183>:
.globl vector183
vector183:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $183
80107591:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107596:	e9 9d f2 ff ff       	jmp    80106838 <alltraps>

8010759b <vector184>:
.globl vector184
vector184:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $184
8010759d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801075a2:	e9 91 f2 ff ff       	jmp    80106838 <alltraps>

801075a7 <vector185>:
.globl vector185
vector185:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $185
801075a9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801075ae:	e9 85 f2 ff ff       	jmp    80106838 <alltraps>

801075b3 <vector186>:
.globl vector186
vector186:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $186
801075b5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801075ba:	e9 79 f2 ff ff       	jmp    80106838 <alltraps>

801075bf <vector187>:
.globl vector187
vector187:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $187
801075c1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801075c6:	e9 6d f2 ff ff       	jmp    80106838 <alltraps>

801075cb <vector188>:
.globl vector188
vector188:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $188
801075cd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801075d2:	e9 61 f2 ff ff       	jmp    80106838 <alltraps>

801075d7 <vector189>:
.globl vector189
vector189:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $189
801075d9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801075de:	e9 55 f2 ff ff       	jmp    80106838 <alltraps>

801075e3 <vector190>:
.globl vector190
vector190:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $190
801075e5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801075ea:	e9 49 f2 ff ff       	jmp    80106838 <alltraps>

801075ef <vector191>:
.globl vector191
vector191:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $191
801075f1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801075f6:	e9 3d f2 ff ff       	jmp    80106838 <alltraps>

801075fb <vector192>:
.globl vector192
vector192:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $192
801075fd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107602:	e9 31 f2 ff ff       	jmp    80106838 <alltraps>

80107607 <vector193>:
.globl vector193
vector193:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $193
80107609:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010760e:	e9 25 f2 ff ff       	jmp    80106838 <alltraps>

80107613 <vector194>:
.globl vector194
vector194:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $194
80107615:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010761a:	e9 19 f2 ff ff       	jmp    80106838 <alltraps>

8010761f <vector195>:
.globl vector195
vector195:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $195
80107621:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107626:	e9 0d f2 ff ff       	jmp    80106838 <alltraps>

8010762b <vector196>:
.globl vector196
vector196:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $196
8010762d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107632:	e9 01 f2 ff ff       	jmp    80106838 <alltraps>

80107637 <vector197>:
.globl vector197
vector197:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $197
80107639:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010763e:	e9 f5 f1 ff ff       	jmp    80106838 <alltraps>

80107643 <vector198>:
.globl vector198
vector198:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $198
80107645:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010764a:	e9 e9 f1 ff ff       	jmp    80106838 <alltraps>

8010764f <vector199>:
.globl vector199
vector199:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $199
80107651:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107656:	e9 dd f1 ff ff       	jmp    80106838 <alltraps>

8010765b <vector200>:
.globl vector200
vector200:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $200
8010765d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107662:	e9 d1 f1 ff ff       	jmp    80106838 <alltraps>

80107667 <vector201>:
.globl vector201
vector201:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $201
80107669:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010766e:	e9 c5 f1 ff ff       	jmp    80106838 <alltraps>

80107673 <vector202>:
.globl vector202
vector202:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $202
80107675:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010767a:	e9 b9 f1 ff ff       	jmp    80106838 <alltraps>

8010767f <vector203>:
.globl vector203
vector203:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $203
80107681:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107686:	e9 ad f1 ff ff       	jmp    80106838 <alltraps>

8010768b <vector204>:
.globl vector204
vector204:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $204
8010768d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107692:	e9 a1 f1 ff ff       	jmp    80106838 <alltraps>

80107697 <vector205>:
.globl vector205
vector205:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $205
80107699:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010769e:	e9 95 f1 ff ff       	jmp    80106838 <alltraps>

801076a3 <vector206>:
.globl vector206
vector206:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $206
801076a5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801076aa:	e9 89 f1 ff ff       	jmp    80106838 <alltraps>

801076af <vector207>:
.globl vector207
vector207:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $207
801076b1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801076b6:	e9 7d f1 ff ff       	jmp    80106838 <alltraps>

801076bb <vector208>:
.globl vector208
vector208:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $208
801076bd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801076c2:	e9 71 f1 ff ff       	jmp    80106838 <alltraps>

801076c7 <vector209>:
.globl vector209
vector209:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $209
801076c9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801076ce:	e9 65 f1 ff ff       	jmp    80106838 <alltraps>

801076d3 <vector210>:
.globl vector210
vector210:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $210
801076d5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801076da:	e9 59 f1 ff ff       	jmp    80106838 <alltraps>

801076df <vector211>:
.globl vector211
vector211:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $211
801076e1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801076e6:	e9 4d f1 ff ff       	jmp    80106838 <alltraps>

801076eb <vector212>:
.globl vector212
vector212:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $212
801076ed:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801076f2:	e9 41 f1 ff ff       	jmp    80106838 <alltraps>

801076f7 <vector213>:
.globl vector213
vector213:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $213
801076f9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801076fe:	e9 35 f1 ff ff       	jmp    80106838 <alltraps>

80107703 <vector214>:
.globl vector214
vector214:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $214
80107705:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010770a:	e9 29 f1 ff ff       	jmp    80106838 <alltraps>

8010770f <vector215>:
.globl vector215
vector215:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $215
80107711:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107716:	e9 1d f1 ff ff       	jmp    80106838 <alltraps>

8010771b <vector216>:
.globl vector216
vector216:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $216
8010771d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107722:	e9 11 f1 ff ff       	jmp    80106838 <alltraps>

80107727 <vector217>:
.globl vector217
vector217:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $217
80107729:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010772e:	e9 05 f1 ff ff       	jmp    80106838 <alltraps>

80107733 <vector218>:
.globl vector218
vector218:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $218
80107735:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010773a:	e9 f9 f0 ff ff       	jmp    80106838 <alltraps>

8010773f <vector219>:
.globl vector219
vector219:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $219
80107741:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107746:	e9 ed f0 ff ff       	jmp    80106838 <alltraps>

8010774b <vector220>:
.globl vector220
vector220:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $220
8010774d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107752:	e9 e1 f0 ff ff       	jmp    80106838 <alltraps>

80107757 <vector221>:
.globl vector221
vector221:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $221
80107759:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010775e:	e9 d5 f0 ff ff       	jmp    80106838 <alltraps>

80107763 <vector222>:
.globl vector222
vector222:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $222
80107765:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010776a:	e9 c9 f0 ff ff       	jmp    80106838 <alltraps>

8010776f <vector223>:
.globl vector223
vector223:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $223
80107771:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107776:	e9 bd f0 ff ff       	jmp    80106838 <alltraps>

8010777b <vector224>:
.globl vector224
vector224:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $224
8010777d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107782:	e9 b1 f0 ff ff       	jmp    80106838 <alltraps>

80107787 <vector225>:
.globl vector225
vector225:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $225
80107789:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010778e:	e9 a5 f0 ff ff       	jmp    80106838 <alltraps>

80107793 <vector226>:
.globl vector226
vector226:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $226
80107795:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010779a:	e9 99 f0 ff ff       	jmp    80106838 <alltraps>

8010779f <vector227>:
.globl vector227
vector227:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $227
801077a1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801077a6:	e9 8d f0 ff ff       	jmp    80106838 <alltraps>

801077ab <vector228>:
.globl vector228
vector228:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $228
801077ad:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801077b2:	e9 81 f0 ff ff       	jmp    80106838 <alltraps>

801077b7 <vector229>:
.globl vector229
vector229:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $229
801077b9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801077be:	e9 75 f0 ff ff       	jmp    80106838 <alltraps>

801077c3 <vector230>:
.globl vector230
vector230:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $230
801077c5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801077ca:	e9 69 f0 ff ff       	jmp    80106838 <alltraps>

801077cf <vector231>:
.globl vector231
vector231:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $231
801077d1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801077d6:	e9 5d f0 ff ff       	jmp    80106838 <alltraps>

801077db <vector232>:
.globl vector232
vector232:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $232
801077dd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801077e2:	e9 51 f0 ff ff       	jmp    80106838 <alltraps>

801077e7 <vector233>:
.globl vector233
vector233:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $233
801077e9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801077ee:	e9 45 f0 ff ff       	jmp    80106838 <alltraps>

801077f3 <vector234>:
.globl vector234
vector234:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $234
801077f5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801077fa:	e9 39 f0 ff ff       	jmp    80106838 <alltraps>

801077ff <vector235>:
.globl vector235
vector235:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $235
80107801:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107806:	e9 2d f0 ff ff       	jmp    80106838 <alltraps>

8010780b <vector236>:
.globl vector236
vector236:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $236
8010780d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107812:	e9 21 f0 ff ff       	jmp    80106838 <alltraps>

80107817 <vector237>:
.globl vector237
vector237:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $237
80107819:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010781e:	e9 15 f0 ff ff       	jmp    80106838 <alltraps>

80107823 <vector238>:
.globl vector238
vector238:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $238
80107825:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010782a:	e9 09 f0 ff ff       	jmp    80106838 <alltraps>

8010782f <vector239>:
.globl vector239
vector239:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $239
80107831:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107836:	e9 fd ef ff ff       	jmp    80106838 <alltraps>

8010783b <vector240>:
.globl vector240
vector240:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $240
8010783d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107842:	e9 f1 ef ff ff       	jmp    80106838 <alltraps>

80107847 <vector241>:
.globl vector241
vector241:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $241
80107849:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010784e:	e9 e5 ef ff ff       	jmp    80106838 <alltraps>

80107853 <vector242>:
.globl vector242
vector242:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $242
80107855:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010785a:	e9 d9 ef ff ff       	jmp    80106838 <alltraps>

8010785f <vector243>:
.globl vector243
vector243:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $243
80107861:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107866:	e9 cd ef ff ff       	jmp    80106838 <alltraps>

8010786b <vector244>:
.globl vector244
vector244:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $244
8010786d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107872:	e9 c1 ef ff ff       	jmp    80106838 <alltraps>

80107877 <vector245>:
.globl vector245
vector245:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $245
80107879:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010787e:	e9 b5 ef ff ff       	jmp    80106838 <alltraps>

80107883 <vector246>:
.globl vector246
vector246:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $246
80107885:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010788a:	e9 a9 ef ff ff       	jmp    80106838 <alltraps>

8010788f <vector247>:
.globl vector247
vector247:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $247
80107891:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107896:	e9 9d ef ff ff       	jmp    80106838 <alltraps>

8010789b <vector248>:
.globl vector248
vector248:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $248
8010789d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801078a2:	e9 91 ef ff ff       	jmp    80106838 <alltraps>

801078a7 <vector249>:
.globl vector249
vector249:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $249
801078a9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801078ae:	e9 85 ef ff ff       	jmp    80106838 <alltraps>

801078b3 <vector250>:
.globl vector250
vector250:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $250
801078b5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801078ba:	e9 79 ef ff ff       	jmp    80106838 <alltraps>

801078bf <vector251>:
.globl vector251
vector251:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $251
801078c1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801078c6:	e9 6d ef ff ff       	jmp    80106838 <alltraps>

801078cb <vector252>:
.globl vector252
vector252:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $252
801078cd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801078d2:	e9 61 ef ff ff       	jmp    80106838 <alltraps>

801078d7 <vector253>:
.globl vector253
vector253:
  pushl $0
801078d7:	6a 00                	push   $0x0
  pushl $253
801078d9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801078de:	e9 55 ef ff ff       	jmp    80106838 <alltraps>

801078e3 <vector254>:
.globl vector254
vector254:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $254
801078e5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801078ea:	e9 49 ef ff ff       	jmp    80106838 <alltraps>

801078ef <vector255>:
.globl vector255
vector255:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $255
801078f1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801078f6:	e9 3d ef ff ff       	jmp    80106838 <alltraps>

801078fb <sgenrand>:
static int mti=N+1; /* mti==N+1 means mt[N] is not initialized */

/* initializing the array with a NONZERO seed */
void
sgenrand(unsigned long seed)
{
801078fb:	55                   	push   %ebp
801078fc:	89 e5                	mov    %esp,%ebp
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
801078fe:	8b 45 08             	mov    0x8(%ebp),%eax
80107901:	a3 80 c6 10 80       	mov    %eax,0x8010c680
    for (mti=1; mti<N; mti++)
80107906:	c7 05 a0 c4 10 80 01 	movl   $0x1,0x8010c4a0
8010790d:	00 00 00 
80107910:	eb 2f                	jmp    80107941 <sgenrand+0x46>
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80107912:	a1 a0 c4 10 80       	mov    0x8010c4a0,%eax
80107917:	8b 15 a0 c4 10 80    	mov    0x8010c4a0,%edx
8010791d:	83 ea 01             	sub    $0x1,%edx
80107920:	8b 14 95 80 c6 10 80 	mov    -0x7fef3980(,%edx,4),%edx
80107927:	69 d2 cd 0d 01 00    	imul   $0x10dcd,%edx,%edx
8010792d:	89 14 85 80 c6 10 80 	mov    %edx,-0x7fef3980(,%eax,4)
    for (mti=1; mti<N; mti++)
80107934:	a1 a0 c4 10 80       	mov    0x8010c4a0,%eax
80107939:	83 c0 01             	add    $0x1,%eax
8010793c:	a3 a0 c4 10 80       	mov    %eax,0x8010c4a0
80107941:	a1 a0 c4 10 80       	mov    0x8010c4a0,%eax
80107946:	3d 6f 02 00 00       	cmp    $0x26f,%eax
8010794b:	7e c5                	jle    80107912 <sgenrand+0x17>
}
8010794d:	90                   	nop
8010794e:	5d                   	pop    %ebp
8010794f:	c3                   	ret    

80107950 <genrand>:

long /* for integer generation */
genrand()
{
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
80107953:	83 ec 10             	sub    $0x10,%esp
    unsigned long y;
    static unsigned long mag01[2]={0x0, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N) { /* generate N words at one time */
80107956:	a1 a0 c4 10 80       	mov    0x8010c4a0,%eax
8010795b:	3d 6f 02 00 00       	cmp    $0x26f,%eax
80107960:	0f 8e 31 01 00 00    	jle    80107a97 <genrand+0x147>
        int kk;

        if (mti == N+1)   /* if sgenrand() has not been called, */
80107966:	a1 a0 c4 10 80       	mov    0x8010c4a0,%eax
8010796b:	3d 71 02 00 00       	cmp    $0x271,%eax
80107970:	75 0d                	jne    8010797f <genrand+0x2f>
            sgenrand(4357); /* a default initial seed is used   */
80107972:	68 05 11 00 00       	push   $0x1105
80107977:	e8 7f ff ff ff       	call   801078fb <sgenrand>
8010797c:	83 c4 04             	add    $0x4,%esp

        for (kk=0;kk<N-M;kk++) {
8010797f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107986:	eb 5b                	jmp    801079e3 <genrand+0x93>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
80107988:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010798b:	8b 04 85 80 c6 10 80 	mov    -0x7fef3980(,%eax,4),%eax
80107992:	25 00 00 00 80       	and    $0x80000000,%eax
80107997:	89 c2                	mov    %eax,%edx
80107999:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010799c:	83 c0 01             	add    $0x1,%eax
8010799f:	8b 04 85 80 c6 10 80 	mov    -0x7fef3980(,%eax,4),%eax
801079a6:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
801079ab:	09 d0                	or     %edx,%eax
801079ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
801079b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079b3:	05 8d 01 00 00       	add    $0x18d,%eax
801079b8:	8b 04 85 80 c6 10 80 	mov    -0x7fef3980(,%eax,4),%eax
801079bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
801079c2:	d1 ea                	shr    %edx
801079c4:	31 c2                	xor    %eax,%edx
801079c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801079c9:	83 e0 01             	and    $0x1,%eax
801079cc:	8b 04 85 a4 c4 10 80 	mov    -0x7fef3b5c(,%eax,4),%eax
801079d3:	31 c2                	xor    %eax,%edx
801079d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079d8:	89 14 85 80 c6 10 80 	mov    %edx,-0x7fef3980(,%eax,4)
        for (kk=0;kk<N-M;kk++) {
801079df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801079e3:	81 7d fc e2 00 00 00 	cmpl   $0xe2,-0x4(%ebp)
801079ea:	7e 9c                	jle    80107988 <genrand+0x38>
        }
        for (;kk<N-1;kk++) {
801079ec:	eb 5b                	jmp    80107a49 <genrand+0xf9>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
801079ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079f1:	8b 04 85 80 c6 10 80 	mov    -0x7fef3980(,%eax,4),%eax
801079f8:	25 00 00 00 80       	and    $0x80000000,%eax
801079fd:	89 c2                	mov    %eax,%edx
801079ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a02:	83 c0 01             	add    $0x1,%eax
80107a05:	8b 04 85 80 c6 10 80 	mov    -0x7fef3980(,%eax,4),%eax
80107a0c:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
80107a11:	09 d0                	or     %edx,%eax
80107a13:	89 45 f8             	mov    %eax,-0x8(%ebp)
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
80107a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a19:	2d e3 00 00 00       	sub    $0xe3,%eax
80107a1e:	8b 04 85 80 c6 10 80 	mov    -0x7fef3980(,%eax,4),%eax
80107a25:	8b 55 f8             	mov    -0x8(%ebp),%edx
80107a28:	d1 ea                	shr    %edx
80107a2a:	31 c2                	xor    %eax,%edx
80107a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107a2f:	83 e0 01             	and    $0x1,%eax
80107a32:	8b 04 85 a4 c4 10 80 	mov    -0x7fef3b5c(,%eax,4),%eax
80107a39:	31 c2                	xor    %eax,%edx
80107a3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a3e:	89 14 85 80 c6 10 80 	mov    %edx,-0x7fef3980(,%eax,4)
        for (;kk<N-1;kk++) {
80107a45:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107a49:	81 7d fc 6e 02 00 00 	cmpl   $0x26e,-0x4(%ebp)
80107a50:	7e 9c                	jle    801079ee <genrand+0x9e>
        }
        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
80107a52:	a1 3c d0 10 80       	mov    0x8010d03c,%eax
80107a57:	25 00 00 00 80       	and    $0x80000000,%eax
80107a5c:	89 c2                	mov    %eax,%edx
80107a5e:	a1 80 c6 10 80       	mov    0x8010c680,%eax
80107a63:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
80107a68:	09 d0                	or     %edx,%eax
80107a6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];
80107a6d:	a1 b0 cc 10 80       	mov    0x8010ccb0,%eax
80107a72:	8b 55 f8             	mov    -0x8(%ebp),%edx
80107a75:	d1 ea                	shr    %edx
80107a77:	31 c2                	xor    %eax,%edx
80107a79:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107a7c:	83 e0 01             	and    $0x1,%eax
80107a7f:	8b 04 85 a4 c4 10 80 	mov    -0x7fef3b5c(,%eax,4),%eax
80107a86:	31 d0                	xor    %edx,%eax
80107a88:	a3 3c d0 10 80       	mov    %eax,0x8010d03c

        mti = 0;
80107a8d:	c7 05 a0 c4 10 80 00 	movl   $0x0,0x8010c4a0
80107a94:	00 00 00 
    }
  
    y = mt[mti++];
80107a97:	a1 a0 c4 10 80       	mov    0x8010c4a0,%eax
80107a9c:	8d 50 01             	lea    0x1(%eax),%edx
80107a9f:	89 15 a0 c4 10 80    	mov    %edx,0x8010c4a0
80107aa5:	8b 04 85 80 c6 10 80 	mov    -0x7fef3980(,%eax,4),%eax
80107aac:	89 45 f8             	mov    %eax,-0x8(%ebp)
    y ^= TEMPERING_SHIFT_U(y);
80107aaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107ab2:	c1 e8 0b             	shr    $0xb,%eax
80107ab5:	31 45 f8             	xor    %eax,-0x8(%ebp)
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
80107ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107abb:	c1 e0 07             	shl    $0x7,%eax
80107abe:	25 80 56 2c 9d       	and    $0x9d2c5680,%eax
80107ac3:	31 45 f8             	xor    %eax,-0x8(%ebp)
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
80107ac6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107ac9:	c1 e0 0f             	shl    $0xf,%eax
80107acc:	25 00 00 c6 ef       	and    $0xefc60000,%eax
80107ad1:	31 45 f8             	xor    %eax,-0x8(%ebp)
    y ^= TEMPERING_SHIFT_L(y);
80107ad4:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107ad7:	c1 e8 12             	shr    $0x12,%eax
80107ada:	31 45 f8             	xor    %eax,-0x8(%ebp)

    // Strip off uppermost bit because we want a long,
    // not an unsigned long
    return y & RAND_MAX;
80107add:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107ae0:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
80107ae5:	c9                   	leave  
80107ae6:	c3                   	ret    

80107ae7 <random_at_most>:

// Assumes 0 <= max <= RAND_MAX
// Returns in the half-open interval [0, max]
long random_at_most(long max) {
80107ae7:	55                   	push   %ebp
80107ae8:	89 e5                	mov    %esp,%ebp
80107aea:	83 ec 20             	sub    $0x20,%esp
  unsigned long
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
    num_bins = (unsigned long) max + 1,
80107aed:	8b 45 08             	mov    0x8(%ebp),%eax
80107af0:	83 c0 01             	add    $0x1,%eax
80107af3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    num_rand = (unsigned long) RAND_MAX + 1,
80107af6:	c7 45 f8 00 00 00 80 	movl   $0x80000000,-0x8(%ebp)
    bin_size = num_rand / num_bins,
80107afd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107b00:	ba 00 00 00 00       	mov    $0x0,%edx
80107b05:	f7 75 fc             	divl   -0x4(%ebp)
80107b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    defect   = num_rand % num_bins;
80107b0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107b0e:	ba 00 00 00 00       	mov    $0x0,%edx
80107b13:	f7 75 fc             	divl   -0x4(%ebp)
80107b16:	89 55 f0             	mov    %edx,-0x10(%ebp)

  long x;
  do {
   x = genrand();
80107b19:	e8 32 fe ff ff       	call   80107950 <genrand>
80107b1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }
  // This is carefully written not to overflow
  while (num_rand - defect <= (unsigned long)x);
80107b21:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107b24:	2b 45 f0             	sub    -0x10(%ebp),%eax
80107b27:	89 c2                	mov    %eax,%edx
80107b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b2c:	39 c2                	cmp    %eax,%edx
80107b2e:	76 e9                	jbe    80107b19 <random_at_most+0x32>

  // Truncated division is intentional
  return x/bin_size;
80107b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b33:	ba 00 00 00 00       	mov    $0x0,%edx
80107b38:	f7 75 f4             	divl   -0xc(%ebp)
}
80107b3b:	c9                   	leave  
80107b3c:	c3                   	ret    

80107b3d <lgdt>:
{
80107b3d:	55                   	push   %ebp
80107b3e:	89 e5                	mov    %esp,%ebp
80107b40:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107b43:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b46:	83 e8 01             	sub    $0x1,%eax
80107b49:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b50:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107b54:	8b 45 08             	mov    0x8(%ebp),%eax
80107b57:	c1 e8 10             	shr    $0x10,%eax
80107b5a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107b5e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107b61:	0f 01 10             	lgdtl  (%eax)
}
80107b64:	90                   	nop
80107b65:	c9                   	leave  
80107b66:	c3                   	ret    

80107b67 <ltr>:
{
80107b67:	55                   	push   %ebp
80107b68:	89 e5                	mov    %esp,%ebp
80107b6a:	83 ec 04             	sub    $0x4,%esp
80107b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b70:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107b74:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107b78:	0f 00 d8             	ltr    %ax
}
80107b7b:	90                   	nop
80107b7c:	c9                   	leave  
80107b7d:	c3                   	ret    

80107b7e <loadgs>:
{
80107b7e:	55                   	push   %ebp
80107b7f:	89 e5                	mov    %esp,%ebp
80107b81:	83 ec 04             	sub    $0x4,%esp
80107b84:	8b 45 08             	mov    0x8(%ebp),%eax
80107b87:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107b8b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107b8f:	8e e8                	mov    %eax,%gs
}
80107b91:	90                   	nop
80107b92:	c9                   	leave  
80107b93:	c3                   	ret    

80107b94 <lcr3>:

static inline void
lcr3(uint val) 
{
80107b94:	55                   	push   %ebp
80107b95:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b97:	8b 45 08             	mov    0x8(%ebp),%eax
80107b9a:	0f 22 d8             	mov    %eax,%cr3
}
80107b9d:	90                   	nop
80107b9e:	5d                   	pop    %ebp
80107b9f:	c3                   	ret    

80107ba0 <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107ba0:	55                   	push   %ebp
80107ba1:	89 e5                	mov    %esp,%ebp
80107ba3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ba6:	05 00 00 00 80       	add    $0x80000000,%eax
80107bab:	5d                   	pop    %ebp
80107bac:	c3                   	ret    

80107bad <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107bad:	55                   	push   %ebp
80107bae:	89 e5                	mov    %esp,%ebp
80107bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80107bb3:	05 00 00 00 80       	add    $0x80000000,%eax
80107bb8:	5d                   	pop    %ebp
80107bb9:	c3                   	ret    

80107bba <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107bba:	55                   	push   %ebp
80107bbb:	89 e5                	mov    %esp,%ebp
80107bbd:	53                   	push   %ebx
80107bbe:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107bc1:	e8 82 b4 ff ff       	call   80103048 <cpunum>
80107bc6:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107bcc:	05 40 3d 11 80       	add    $0x80113d40,%eax
80107bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd7:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be0:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be9:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf0:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107bf4:	83 e2 f0             	and    $0xfffffff0,%edx
80107bf7:	83 ca 0a             	or     $0xa,%edx
80107bfa:	88 50 7d             	mov    %dl,0x7d(%eax)
80107bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c00:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c04:	83 ca 10             	or     $0x10,%edx
80107c07:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c0d:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c11:	83 e2 9f             	and    $0xffffff9f,%edx
80107c14:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c1e:	83 ca 80             	or     $0xffffff80,%edx
80107c21:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c27:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c2b:	83 ca 0f             	or     $0xf,%edx
80107c2e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c34:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c38:	83 e2 ef             	and    $0xffffffef,%edx
80107c3b:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c41:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c45:	83 e2 df             	and    $0xffffffdf,%edx
80107c48:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c4e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c52:	83 ca 40             	or     $0x40,%edx
80107c55:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c5f:	83 ca 80             	or     $0xffffff80,%edx
80107c62:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c68:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6f:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107c76:	ff ff 
80107c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7b:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107c82:	00 00 
80107c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c87:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c91:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107c98:	83 e2 f0             	and    $0xfffffff0,%edx
80107c9b:	83 ca 02             	or     $0x2,%edx
80107c9e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca7:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107cae:	83 ca 10             	or     $0x10,%edx
80107cb1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cba:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107cc1:	83 e2 9f             	and    $0xffffff9f,%edx
80107cc4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccd:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107cd4:	83 ca 80             	or     $0xffffff80,%edx
80107cd7:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ce7:	83 ca 0f             	or     $0xf,%edx
80107cea:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107cfa:	83 e2 ef             	and    $0xffffffef,%edx
80107cfd:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d06:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d0d:	83 e2 df             	and    $0xffffffdf,%edx
80107d10:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d19:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d20:	83 ca 40             	or     $0x40,%edx
80107d23:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d33:	83 ca 80             	or     $0xffffff80,%edx
80107d36:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3f:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d49:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107d50:	ff ff 
80107d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d55:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107d5c:	00 00 
80107d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d61:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107d72:	83 e2 f0             	and    $0xfffffff0,%edx
80107d75:	83 ca 0a             	or     $0xa,%edx
80107d78:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d81:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107d88:	83 ca 10             	or     $0x10,%edx
80107d8b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d94:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107d9b:	83 ca 60             	or     $0x60,%edx
80107d9e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da7:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107dae:	83 ca 80             	or     $0xffffff80,%edx
80107db1:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dba:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107dc1:	83 ca 0f             	or     $0xf,%edx
80107dc4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dcd:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107dd4:	83 e2 ef             	and    $0xffffffef,%edx
80107dd7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107de7:	83 e2 df             	and    $0xffffffdf,%edx
80107dea:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107dfa:	83 ca 40             	or     $0x40,%edx
80107dfd:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e06:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e0d:	83 ca 80             	or     $0xffffff80,%edx
80107e10:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e19:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e23:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107e2a:	ff ff 
80107e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e2f:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107e36:	00 00 
80107e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3b:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e45:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e4c:	83 e2 f0             	and    $0xfffffff0,%edx
80107e4f:	83 ca 02             	or     $0x2,%edx
80107e52:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5b:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e62:	83 ca 10             	or     $0x10,%edx
80107e65:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e75:	83 ca 60             	or     $0x60,%edx
80107e78:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e81:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e88:	83 ca 80             	or     $0xffffff80,%edx
80107e8b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e94:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107e9b:	83 ca 0f             	or     $0xf,%edx
80107e9e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107eae:	83 e2 ef             	and    $0xffffffef,%edx
80107eb1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eba:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ec1:	83 e2 df             	and    $0xffffffdf,%edx
80107ec4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ecd:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ed4:	83 ca 40             	or     $0x40,%edx
80107ed7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee0:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ee7:	83 ca 80             	or     $0xffffff80,%edx
80107eea:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef3:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efd:	05 b4 00 00 00       	add    $0xb4,%eax
80107f02:	89 c3                	mov    %eax,%ebx
80107f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f07:	05 b4 00 00 00       	add    $0xb4,%eax
80107f0c:	c1 e8 10             	shr    $0x10,%eax
80107f0f:	89 c2                	mov    %eax,%edx
80107f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f14:	05 b4 00 00 00       	add    $0xb4,%eax
80107f19:	c1 e8 18             	shr    $0x18,%eax
80107f1c:	89 c1                	mov    %eax,%ecx
80107f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f21:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107f28:	00 00 
80107f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2d:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f37:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f40:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f47:	83 e2 f0             	and    $0xfffffff0,%edx
80107f4a:	83 ca 02             	or     $0x2,%edx
80107f4d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f56:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f5d:	83 ca 10             	or     $0x10,%edx
80107f60:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f69:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f70:	83 e2 9f             	and    $0xffffff9f,%edx
80107f73:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f83:	83 ca 80             	or     $0xffffff80,%edx
80107f86:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f96:	83 e2 f0             	and    $0xfffffff0,%edx
80107f99:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa2:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107fa9:	83 e2 ef             	and    $0xffffffef,%edx
80107fac:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb5:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107fbc:	83 e2 df             	and    $0xffffffdf,%edx
80107fbf:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc8:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107fcf:	83 ca 40             	or     $0x40,%edx
80107fd2:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdb:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107fe2:	83 ca 80             	or     $0xffffff80,%edx
80107fe5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fee:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff7:	83 c0 70             	add    $0x70,%eax
80107ffa:	83 ec 08             	sub    $0x8,%esp
80107ffd:	6a 38                	push   $0x38
80107fff:	50                   	push   %eax
80108000:	e8 38 fb ff ff       	call   80107b3d <lgdt>
80108005:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108008:	83 ec 0c             	sub    $0xc,%esp
8010800b:	6a 18                	push   $0x18
8010800d:	e8 6c fb ff ff       	call   80107b7e <loadgs>
80108012:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108018:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010801e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108025:	00 00 00 00 
}
80108029:	90                   	nop
8010802a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010802d:	c9                   	leave  
8010802e:	c3                   	ret    

8010802f <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010802f:	55                   	push   %ebp
80108030:	89 e5                	mov    %esp,%ebp
80108032:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108035:	8b 45 0c             	mov    0xc(%ebp),%eax
80108038:	c1 e8 16             	shr    $0x16,%eax
8010803b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108042:	8b 45 08             	mov    0x8(%ebp),%eax
80108045:	01 d0                	add    %edx,%eax
80108047:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010804a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010804d:	8b 00                	mov    (%eax),%eax
8010804f:	83 e0 01             	and    $0x1,%eax
80108052:	85 c0                	test   %eax,%eax
80108054:	74 18                	je     8010806e <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108056:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108059:	8b 00                	mov    (%eax),%eax
8010805b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108060:	50                   	push   %eax
80108061:	e8 47 fb ff ff       	call   80107bad <p2v>
80108066:	83 c4 04             	add    $0x4,%esp
80108069:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010806c:	eb 48                	jmp    801080b6 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010806e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108072:	74 0e                	je     80108082 <walkpgdir+0x53>
80108074:	e8 69 ac ff ff       	call   80102ce2 <kalloc>
80108079:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010807c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108080:	75 07                	jne    80108089 <walkpgdir+0x5a>
      return 0;
80108082:	b8 00 00 00 00       	mov    $0x0,%eax
80108087:	eb 44                	jmp    801080cd <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108089:	83 ec 04             	sub    $0x4,%esp
8010808c:	68 00 10 00 00       	push   $0x1000
80108091:	6a 00                	push   $0x0
80108093:	ff 75 f4             	pushl  -0xc(%ebp)
80108096:	e8 76 d3 ff ff       	call   80105411 <memset>
8010809b:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
8010809e:	83 ec 0c             	sub    $0xc,%esp
801080a1:	ff 75 f4             	pushl  -0xc(%ebp)
801080a4:	e8 f7 fa ff ff       	call   80107ba0 <v2p>
801080a9:	83 c4 10             	add    $0x10,%esp
801080ac:	83 c8 07             	or     $0x7,%eax
801080af:	89 c2                	mov    %eax,%edx
801080b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080b4:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801080b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801080b9:	c1 e8 0c             	shr    $0xc,%eax
801080bc:	25 ff 03 00 00       	and    $0x3ff,%eax
801080c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801080c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cb:	01 d0                	add    %edx,%eax
}
801080cd:	c9                   	leave  
801080ce:	c3                   	ret    

801080cf <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801080cf:	55                   	push   %ebp
801080d0:	89 e5                	mov    %esp,%ebp
801080d2:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801080d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801080d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801080e0:	8b 55 0c             	mov    0xc(%ebp),%edx
801080e3:	8b 45 10             	mov    0x10(%ebp),%eax
801080e6:	01 d0                	add    %edx,%eax
801080e8:	83 e8 01             	sub    $0x1,%eax
801080eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801080f3:	83 ec 04             	sub    $0x4,%esp
801080f6:	6a 01                	push   $0x1
801080f8:	ff 75 f4             	pushl  -0xc(%ebp)
801080fb:	ff 75 08             	pushl  0x8(%ebp)
801080fe:	e8 2c ff ff ff       	call   8010802f <walkpgdir>
80108103:	83 c4 10             	add    $0x10,%esp
80108106:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108109:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010810d:	75 07                	jne    80108116 <mappages+0x47>
      return -1;
8010810f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108114:	eb 47                	jmp    8010815d <mappages+0x8e>
    if(*pte & PTE_P)
80108116:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108119:	8b 00                	mov    (%eax),%eax
8010811b:	83 e0 01             	and    $0x1,%eax
8010811e:	85 c0                	test   %eax,%eax
80108120:	74 0d                	je     8010812f <mappages+0x60>
      panic("remap");
80108122:	83 ec 0c             	sub    $0xc,%esp
80108125:	68 84 8f 10 80       	push   $0x80108f84
8010812a:	e8 b3 84 ff ff       	call   801005e2 <panic>
    *pte = pa | perm | PTE_P;
8010812f:	8b 45 18             	mov    0x18(%ebp),%eax
80108132:	0b 45 14             	or     0x14(%ebp),%eax
80108135:	83 c8 01             	or     $0x1,%eax
80108138:	89 c2                	mov    %eax,%edx
8010813a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010813d:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010813f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108142:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108145:	74 10                	je     80108157 <mappages+0x88>
      break;
    a += PGSIZE;
80108147:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010814e:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108155:	eb 9c                	jmp    801080f3 <mappages+0x24>
      break;
80108157:	90                   	nop
  }
  return 0;
80108158:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010815d:	c9                   	leave  
8010815e:	c3                   	ret    

8010815f <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010815f:	55                   	push   %ebp
80108160:	89 e5                	mov    %esp,%ebp
80108162:	53                   	push   %ebx
80108163:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108166:	e8 77 ab ff ff       	call   80102ce2 <kalloc>
8010816b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010816e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108172:	75 0a                	jne    8010817e <setupkvm+0x1f>
    return 0;
80108174:	b8 00 00 00 00       	mov    $0x0,%eax
80108179:	e9 8e 00 00 00       	jmp    8010820c <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
8010817e:	83 ec 04             	sub    $0x4,%esp
80108181:	68 00 10 00 00       	push   $0x1000
80108186:	6a 00                	push   $0x0
80108188:	ff 75 f0             	pushl  -0x10(%ebp)
8010818b:	e8 81 d2 ff ff       	call   80105411 <memset>
80108190:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108193:	83 ec 0c             	sub    $0xc,%esp
80108196:	68 00 00 00 0e       	push   $0xe000000
8010819b:	e8 0d fa ff ff       	call   80107bad <p2v>
801081a0:	83 c4 10             	add    $0x10,%esp
801081a3:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801081a8:	76 0d                	jbe    801081b7 <setupkvm+0x58>
    panic("PHYSTOP too high");
801081aa:	83 ec 0c             	sub    $0xc,%esp
801081ad:	68 8a 8f 10 80       	push   $0x80108f8a
801081b2:	e8 2b 84 ff ff       	call   801005e2 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801081b7:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
801081be:	eb 40                	jmp    80108200 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801081c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c3:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801081c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c9:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801081cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cf:	8b 58 08             	mov    0x8(%eax),%ebx
801081d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d5:	8b 40 04             	mov    0x4(%eax),%eax
801081d8:	29 c3                	sub    %eax,%ebx
801081da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081dd:	8b 00                	mov    (%eax),%eax
801081df:	83 ec 0c             	sub    $0xc,%esp
801081e2:	51                   	push   %ecx
801081e3:	52                   	push   %edx
801081e4:	53                   	push   %ebx
801081e5:	50                   	push   %eax
801081e6:	ff 75 f0             	pushl  -0x10(%ebp)
801081e9:	e8 e1 fe ff ff       	call   801080cf <mappages>
801081ee:	83 c4 20             	add    $0x20,%esp
801081f1:	85 c0                	test   %eax,%eax
801081f3:	79 07                	jns    801081fc <setupkvm+0x9d>
      return 0;
801081f5:	b8 00 00 00 00       	mov    $0x0,%eax
801081fa:	eb 10                	jmp    8010820c <setupkvm+0xad>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801081fc:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108200:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108207:	72 b7                	jb     801081c0 <setupkvm+0x61>
  return pgdir;
80108209:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010820c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010820f:	c9                   	leave  
80108210:	c3                   	ret    

80108211 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108211:	55                   	push   %ebp
80108212:	89 e5                	mov    %esp,%ebp
80108214:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108217:	e8 43 ff ff ff       	call   8010815f <setupkvm>
8010821c:	a3 38 6c 11 80       	mov    %eax,0x80116c38
  switchkvm();
80108221:	e8 03 00 00 00       	call   80108229 <switchkvm>
}
80108226:	90                   	nop
80108227:	c9                   	leave  
80108228:	c3                   	ret    

80108229 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108229:	55                   	push   %ebp
8010822a:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010822c:	a1 38 6c 11 80       	mov    0x80116c38,%eax
80108231:	50                   	push   %eax
80108232:	e8 69 f9 ff ff       	call   80107ba0 <v2p>
80108237:	83 c4 04             	add    $0x4,%esp
8010823a:	50                   	push   %eax
8010823b:	e8 54 f9 ff ff       	call   80107b94 <lcr3>
80108240:	83 c4 04             	add    $0x4,%esp
}
80108243:	90                   	nop
80108244:	c9                   	leave  
80108245:	c3                   	ret    

80108246 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108246:	55                   	push   %ebp
80108247:	89 e5                	mov    %esp,%ebp
80108249:	56                   	push   %esi
8010824a:	53                   	push   %ebx
  pushcli();
8010824b:	e8 bb d0 ff ff       	call   8010530b <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108250:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108256:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010825d:	83 c2 08             	add    $0x8,%edx
80108260:	89 d6                	mov    %edx,%esi
80108262:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108269:	83 c2 08             	add    $0x8,%edx
8010826c:	c1 ea 10             	shr    $0x10,%edx
8010826f:	89 d3                	mov    %edx,%ebx
80108271:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108278:	83 c2 08             	add    $0x8,%edx
8010827b:	c1 ea 18             	shr    $0x18,%edx
8010827e:	89 d1                	mov    %edx,%ecx
80108280:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108287:	67 00 
80108289:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108290:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108296:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010829d:	83 e2 f0             	and    $0xfffffff0,%edx
801082a0:	83 ca 09             	or     $0x9,%edx
801082a3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801082a9:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801082b0:	83 ca 10             	or     $0x10,%edx
801082b3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801082b9:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801082c0:	83 e2 9f             	and    $0xffffff9f,%edx
801082c3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801082c9:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801082d0:	83 ca 80             	or     $0xffffff80,%edx
801082d3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801082d9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801082e0:	83 e2 f0             	and    $0xfffffff0,%edx
801082e3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801082e9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801082f0:	83 e2 ef             	and    $0xffffffef,%edx
801082f3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801082f9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108300:	83 e2 df             	and    $0xffffffdf,%edx
80108303:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108309:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108310:	83 ca 40             	or     $0x40,%edx
80108313:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108319:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108320:	83 e2 7f             	and    $0x7f,%edx
80108323:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108329:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010832f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108335:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010833c:	83 e2 ef             	and    $0xffffffef,%edx
8010833f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108345:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010834b:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108351:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108357:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010835e:	8b 52 08             	mov    0x8(%edx),%edx
80108361:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108367:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010836a:	83 ec 0c             	sub    $0xc,%esp
8010836d:	6a 30                	push   $0x30
8010836f:	e8 f3 f7 ff ff       	call   80107b67 <ltr>
80108374:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108377:	8b 45 08             	mov    0x8(%ebp),%eax
8010837a:	8b 40 04             	mov    0x4(%eax),%eax
8010837d:	85 c0                	test   %eax,%eax
8010837f:	75 0d                	jne    8010838e <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108381:	83 ec 0c             	sub    $0xc,%esp
80108384:	68 9b 8f 10 80       	push   $0x80108f9b
80108389:	e8 54 82 ff ff       	call   801005e2 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010838e:	8b 45 08             	mov    0x8(%ebp),%eax
80108391:	8b 40 04             	mov    0x4(%eax),%eax
80108394:	83 ec 0c             	sub    $0xc,%esp
80108397:	50                   	push   %eax
80108398:	e8 03 f8 ff ff       	call   80107ba0 <v2p>
8010839d:	83 c4 10             	add    $0x10,%esp
801083a0:	83 ec 0c             	sub    $0xc,%esp
801083a3:	50                   	push   %eax
801083a4:	e8 eb f7 ff ff       	call   80107b94 <lcr3>
801083a9:	83 c4 10             	add    $0x10,%esp
  popcli();
801083ac:	e8 9f cf ff ff       	call   80105350 <popcli>
}
801083b1:	90                   	nop
801083b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801083b5:	5b                   	pop    %ebx
801083b6:	5e                   	pop    %esi
801083b7:	5d                   	pop    %ebp
801083b8:	c3                   	ret    

801083b9 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801083b9:	55                   	push   %ebp
801083ba:	89 e5                	mov    %esp,%ebp
801083bc:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801083bf:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801083c6:	76 0d                	jbe    801083d5 <inituvm+0x1c>
    panic("inituvm: more than a page");
801083c8:	83 ec 0c             	sub    $0xc,%esp
801083cb:	68 af 8f 10 80       	push   $0x80108faf
801083d0:	e8 0d 82 ff ff       	call   801005e2 <panic>
  mem = kalloc();
801083d5:	e8 08 a9 ff ff       	call   80102ce2 <kalloc>
801083da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801083dd:	83 ec 04             	sub    $0x4,%esp
801083e0:	68 00 10 00 00       	push   $0x1000
801083e5:	6a 00                	push   $0x0
801083e7:	ff 75 f4             	pushl  -0xc(%ebp)
801083ea:	e8 22 d0 ff ff       	call   80105411 <memset>
801083ef:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801083f2:	83 ec 0c             	sub    $0xc,%esp
801083f5:	ff 75 f4             	pushl  -0xc(%ebp)
801083f8:	e8 a3 f7 ff ff       	call   80107ba0 <v2p>
801083fd:	83 c4 10             	add    $0x10,%esp
80108400:	83 ec 0c             	sub    $0xc,%esp
80108403:	6a 06                	push   $0x6
80108405:	50                   	push   %eax
80108406:	68 00 10 00 00       	push   $0x1000
8010840b:	6a 00                	push   $0x0
8010840d:	ff 75 08             	pushl  0x8(%ebp)
80108410:	e8 ba fc ff ff       	call   801080cf <mappages>
80108415:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108418:	83 ec 04             	sub    $0x4,%esp
8010841b:	ff 75 10             	pushl  0x10(%ebp)
8010841e:	ff 75 0c             	pushl  0xc(%ebp)
80108421:	ff 75 f4             	pushl  -0xc(%ebp)
80108424:	e8 a7 d0 ff ff       	call   801054d0 <memmove>
80108429:	83 c4 10             	add    $0x10,%esp
}
8010842c:	90                   	nop
8010842d:	c9                   	leave  
8010842e:	c3                   	ret    

8010842f <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010842f:	55                   	push   %ebp
80108430:	89 e5                	mov    %esp,%ebp
80108432:	53                   	push   %ebx
80108433:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108436:	8b 45 0c             	mov    0xc(%ebp),%eax
80108439:	25 ff 0f 00 00       	and    $0xfff,%eax
8010843e:	85 c0                	test   %eax,%eax
80108440:	74 0d                	je     8010844f <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108442:	83 ec 0c             	sub    $0xc,%esp
80108445:	68 cc 8f 10 80       	push   $0x80108fcc
8010844a:	e8 93 81 ff ff       	call   801005e2 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010844f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108456:	e9 95 00 00 00       	jmp    801084f0 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010845b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010845e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108461:	01 d0                	add    %edx,%eax
80108463:	83 ec 04             	sub    $0x4,%esp
80108466:	6a 00                	push   $0x0
80108468:	50                   	push   %eax
80108469:	ff 75 08             	pushl  0x8(%ebp)
8010846c:	e8 be fb ff ff       	call   8010802f <walkpgdir>
80108471:	83 c4 10             	add    $0x10,%esp
80108474:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108477:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010847b:	75 0d                	jne    8010848a <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010847d:	83 ec 0c             	sub    $0xc,%esp
80108480:	68 ef 8f 10 80       	push   $0x80108fef
80108485:	e8 58 81 ff ff       	call   801005e2 <panic>
    pa = PTE_ADDR(*pte);
8010848a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010848d:	8b 00                	mov    (%eax),%eax
8010848f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108494:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108497:	8b 45 18             	mov    0x18(%ebp),%eax
8010849a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010849d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801084a2:	77 0b                	ja     801084af <loaduvm+0x80>
      n = sz - i;
801084a4:	8b 45 18             	mov    0x18(%ebp),%eax
801084a7:	2b 45 f4             	sub    -0xc(%ebp),%eax
801084aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
801084ad:	eb 07                	jmp    801084b6 <loaduvm+0x87>
    else
      n = PGSIZE;
801084af:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801084b6:	8b 55 14             	mov    0x14(%ebp),%edx
801084b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084bc:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801084bf:	83 ec 0c             	sub    $0xc,%esp
801084c2:	ff 75 e8             	pushl  -0x18(%ebp)
801084c5:	e8 e3 f6 ff ff       	call   80107bad <p2v>
801084ca:	83 c4 10             	add    $0x10,%esp
801084cd:	ff 75 f0             	pushl  -0x10(%ebp)
801084d0:	53                   	push   %ebx
801084d1:	50                   	push   %eax
801084d2:	ff 75 10             	pushl  0x10(%ebp)
801084d5:	e8 7a 9a ff ff       	call   80101f54 <readi>
801084da:	83 c4 10             	add    $0x10,%esp
801084dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801084e0:	74 07                	je     801084e9 <loaduvm+0xba>
      return -1;
801084e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801084e7:	eb 18                	jmp    80108501 <loaduvm+0xd2>
  for(i = 0; i < sz; i += PGSIZE){
801084e9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801084f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084f3:	3b 45 18             	cmp    0x18(%ebp),%eax
801084f6:	0f 82 5f ff ff ff    	jb     8010845b <loaduvm+0x2c>
  }
  return 0;
801084fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108501:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108504:	c9                   	leave  
80108505:	c3                   	ret    

80108506 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108506:	55                   	push   %ebp
80108507:	89 e5                	mov    %esp,%ebp
80108509:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010850c:	8b 45 10             	mov    0x10(%ebp),%eax
8010850f:	85 c0                	test   %eax,%eax
80108511:	79 0a                	jns    8010851d <allocuvm+0x17>
    return 0;
80108513:	b8 00 00 00 00       	mov    $0x0,%eax
80108518:	e9 b0 00 00 00       	jmp    801085cd <allocuvm+0xc7>
  if(newsz < oldsz)
8010851d:	8b 45 10             	mov    0x10(%ebp),%eax
80108520:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108523:	73 08                	jae    8010852d <allocuvm+0x27>
    return oldsz;
80108525:	8b 45 0c             	mov    0xc(%ebp),%eax
80108528:	e9 a0 00 00 00       	jmp    801085cd <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
8010852d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108530:	05 ff 0f 00 00       	add    $0xfff,%eax
80108535:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010853a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010853d:	eb 7f                	jmp    801085be <allocuvm+0xb8>
    mem = kalloc();
8010853f:	e8 9e a7 ff ff       	call   80102ce2 <kalloc>
80108544:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108547:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010854b:	75 2b                	jne    80108578 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
8010854d:	83 ec 0c             	sub    $0xc,%esp
80108550:	68 0d 90 10 80       	push   $0x8010900d
80108555:	e8 c0 7e ff ff       	call   8010041a <cprintf>
8010855a:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010855d:	83 ec 04             	sub    $0x4,%esp
80108560:	ff 75 0c             	pushl  0xc(%ebp)
80108563:	ff 75 10             	pushl  0x10(%ebp)
80108566:	ff 75 08             	pushl  0x8(%ebp)
80108569:	e8 61 00 00 00       	call   801085cf <deallocuvm>
8010856e:	83 c4 10             	add    $0x10,%esp
      return 0;
80108571:	b8 00 00 00 00       	mov    $0x0,%eax
80108576:	eb 55                	jmp    801085cd <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108578:	83 ec 04             	sub    $0x4,%esp
8010857b:	68 00 10 00 00       	push   $0x1000
80108580:	6a 00                	push   $0x0
80108582:	ff 75 f0             	pushl  -0x10(%ebp)
80108585:	e8 87 ce ff ff       	call   80105411 <memset>
8010858a:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010858d:	83 ec 0c             	sub    $0xc,%esp
80108590:	ff 75 f0             	pushl  -0x10(%ebp)
80108593:	e8 08 f6 ff ff       	call   80107ba0 <v2p>
80108598:	83 c4 10             	add    $0x10,%esp
8010859b:	89 c2                	mov    %eax,%edx
8010859d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a0:	83 ec 0c             	sub    $0xc,%esp
801085a3:	6a 06                	push   $0x6
801085a5:	52                   	push   %edx
801085a6:	68 00 10 00 00       	push   $0x1000
801085ab:	50                   	push   %eax
801085ac:	ff 75 08             	pushl  0x8(%ebp)
801085af:	e8 1b fb ff ff       	call   801080cf <mappages>
801085b4:	83 c4 20             	add    $0x20,%esp
  for(; a < newsz; a += PGSIZE){
801085b7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801085be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c1:	3b 45 10             	cmp    0x10(%ebp),%eax
801085c4:	0f 82 75 ff ff ff    	jb     8010853f <allocuvm+0x39>
  }
  return newsz;
801085ca:	8b 45 10             	mov    0x10(%ebp),%eax
}
801085cd:	c9                   	leave  
801085ce:	c3                   	ret    

801085cf <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801085cf:	55                   	push   %ebp
801085d0:	89 e5                	mov    %esp,%ebp
801085d2:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801085d5:	8b 45 10             	mov    0x10(%ebp),%eax
801085d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801085db:	72 08                	jb     801085e5 <deallocuvm+0x16>
    return oldsz;
801085dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801085e0:	e9 a5 00 00 00       	jmp    8010868a <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801085e5:	8b 45 10             	mov    0x10(%ebp),%eax
801085e8:	05 ff 0f 00 00       	add    $0xfff,%eax
801085ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801085f5:	e9 81 00 00 00       	jmp    8010867b <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801085fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085fd:	83 ec 04             	sub    $0x4,%esp
80108600:	6a 00                	push   $0x0
80108602:	50                   	push   %eax
80108603:	ff 75 08             	pushl  0x8(%ebp)
80108606:	e8 24 fa ff ff       	call   8010802f <walkpgdir>
8010860b:	83 c4 10             	add    $0x10,%esp
8010860e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108611:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108615:	75 09                	jne    80108620 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108617:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010861e:	eb 54                	jmp    80108674 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108620:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108623:	8b 00                	mov    (%eax),%eax
80108625:	83 e0 01             	and    $0x1,%eax
80108628:	85 c0                	test   %eax,%eax
8010862a:	74 48                	je     80108674 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
8010862c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010862f:	8b 00                	mov    (%eax),%eax
80108631:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108636:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108639:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010863d:	75 0d                	jne    8010864c <deallocuvm+0x7d>
        panic("kfree");
8010863f:	83 ec 0c             	sub    $0xc,%esp
80108642:	68 25 90 10 80       	push   $0x80109025
80108647:	e8 96 7f ff ff       	call   801005e2 <panic>
      char *v = p2v(pa);
8010864c:	83 ec 0c             	sub    $0xc,%esp
8010864f:	ff 75 ec             	pushl  -0x14(%ebp)
80108652:	e8 56 f5 ff ff       	call   80107bad <p2v>
80108657:	83 c4 10             	add    $0x10,%esp
8010865a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010865d:	83 ec 0c             	sub    $0xc,%esp
80108660:	ff 75 e8             	pushl  -0x18(%ebp)
80108663:	e8 dd a5 ff ff       	call   80102c45 <kfree>
80108668:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
8010866b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010866e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108674:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010867b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010867e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108681:	0f 82 73 ff ff ff    	jb     801085fa <deallocuvm+0x2b>
    }
  }
  return newsz;
80108687:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010868a:	c9                   	leave  
8010868b:	c3                   	ret    

8010868c <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010868c:	55                   	push   %ebp
8010868d:	89 e5                	mov    %esp,%ebp
8010868f:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108692:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108696:	75 0d                	jne    801086a5 <freevm+0x19>
    panic("freevm: no pgdir");
80108698:	83 ec 0c             	sub    $0xc,%esp
8010869b:	68 2b 90 10 80       	push   $0x8010902b
801086a0:	e8 3d 7f ff ff       	call   801005e2 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801086a5:	83 ec 04             	sub    $0x4,%esp
801086a8:	6a 00                	push   $0x0
801086aa:	68 00 00 00 80       	push   $0x80000000
801086af:	ff 75 08             	pushl  0x8(%ebp)
801086b2:	e8 18 ff ff ff       	call   801085cf <deallocuvm>
801086b7:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801086ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801086c1:	eb 4f                	jmp    80108712 <freevm+0x86>
    if(pgdir[i] & PTE_P){
801086c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801086cd:	8b 45 08             	mov    0x8(%ebp),%eax
801086d0:	01 d0                	add    %edx,%eax
801086d2:	8b 00                	mov    (%eax),%eax
801086d4:	83 e0 01             	and    $0x1,%eax
801086d7:	85 c0                	test   %eax,%eax
801086d9:	74 33                	je     8010870e <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801086db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801086e5:	8b 45 08             	mov    0x8(%ebp),%eax
801086e8:	01 d0                	add    %edx,%eax
801086ea:	8b 00                	mov    (%eax),%eax
801086ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086f1:	83 ec 0c             	sub    $0xc,%esp
801086f4:	50                   	push   %eax
801086f5:	e8 b3 f4 ff ff       	call   80107bad <p2v>
801086fa:	83 c4 10             	add    $0x10,%esp
801086fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108700:	83 ec 0c             	sub    $0xc,%esp
80108703:	ff 75 f0             	pushl  -0x10(%ebp)
80108706:	e8 3a a5 ff ff       	call   80102c45 <kfree>
8010870b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010870e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108712:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108719:	76 a8                	jbe    801086c3 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010871b:	83 ec 0c             	sub    $0xc,%esp
8010871e:	ff 75 08             	pushl  0x8(%ebp)
80108721:	e8 1f a5 ff ff       	call   80102c45 <kfree>
80108726:	83 c4 10             	add    $0x10,%esp
}
80108729:	90                   	nop
8010872a:	c9                   	leave  
8010872b:	c3                   	ret    

8010872c <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010872c:	55                   	push   %ebp
8010872d:	89 e5                	mov    %esp,%ebp
8010872f:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108732:	83 ec 04             	sub    $0x4,%esp
80108735:	6a 00                	push   $0x0
80108737:	ff 75 0c             	pushl  0xc(%ebp)
8010873a:	ff 75 08             	pushl  0x8(%ebp)
8010873d:	e8 ed f8 ff ff       	call   8010802f <walkpgdir>
80108742:	83 c4 10             	add    $0x10,%esp
80108745:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108748:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010874c:	75 0d                	jne    8010875b <clearpteu+0x2f>
    panic("clearpteu");
8010874e:	83 ec 0c             	sub    $0xc,%esp
80108751:	68 3c 90 10 80       	push   $0x8010903c
80108756:	e8 87 7e ff ff       	call   801005e2 <panic>
  *pte &= ~PTE_U;
8010875b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010875e:	8b 00                	mov    (%eax),%eax
80108760:	83 e0 fb             	and    $0xfffffffb,%eax
80108763:	89 c2                	mov    %eax,%edx
80108765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108768:	89 10                	mov    %edx,(%eax)
}
8010876a:	90                   	nop
8010876b:	c9                   	leave  
8010876c:	c3                   	ret    

8010876d <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010876d:	55                   	push   %ebp
8010876e:	89 e5                	mov    %esp,%ebp
80108770:	53                   	push   %ebx
80108771:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108774:	e8 e6 f9 ff ff       	call   8010815f <setupkvm>
80108779:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010877c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108780:	75 0a                	jne    8010878c <copyuvm+0x1f>
    return 0;
80108782:	b8 00 00 00 00       	mov    $0x0,%eax
80108787:	e9 f8 00 00 00       	jmp    80108884 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
8010878c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108793:	e9 c4 00 00 00       	jmp    8010885c <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010879b:	83 ec 04             	sub    $0x4,%esp
8010879e:	6a 00                	push   $0x0
801087a0:	50                   	push   %eax
801087a1:	ff 75 08             	pushl  0x8(%ebp)
801087a4:	e8 86 f8 ff ff       	call   8010802f <walkpgdir>
801087a9:	83 c4 10             	add    $0x10,%esp
801087ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
801087af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087b3:	75 0d                	jne    801087c2 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801087b5:	83 ec 0c             	sub    $0xc,%esp
801087b8:	68 46 90 10 80       	push   $0x80109046
801087bd:	e8 20 7e ff ff       	call   801005e2 <panic>
    if(!(*pte & PTE_P))
801087c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087c5:	8b 00                	mov    (%eax),%eax
801087c7:	83 e0 01             	and    $0x1,%eax
801087ca:	85 c0                	test   %eax,%eax
801087cc:	75 0d                	jne    801087db <copyuvm+0x6e>
      panic("copyuvm: page not present");
801087ce:	83 ec 0c             	sub    $0xc,%esp
801087d1:	68 60 90 10 80       	push   $0x80109060
801087d6:	e8 07 7e ff ff       	call   801005e2 <panic>
    pa = PTE_ADDR(*pte);
801087db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087de:	8b 00                	mov    (%eax),%eax
801087e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801087e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087eb:	8b 00                	mov    (%eax),%eax
801087ed:	25 ff 0f 00 00       	and    $0xfff,%eax
801087f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801087f5:	e8 e8 a4 ff ff       	call   80102ce2 <kalloc>
801087fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
801087fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108801:	74 6a                	je     8010886d <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108803:	83 ec 0c             	sub    $0xc,%esp
80108806:	ff 75 e8             	pushl  -0x18(%ebp)
80108809:	e8 9f f3 ff ff       	call   80107bad <p2v>
8010880e:	83 c4 10             	add    $0x10,%esp
80108811:	83 ec 04             	sub    $0x4,%esp
80108814:	68 00 10 00 00       	push   $0x1000
80108819:	50                   	push   %eax
8010881a:	ff 75 e0             	pushl  -0x20(%ebp)
8010881d:	e8 ae cc ff ff       	call   801054d0 <memmove>
80108822:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108825:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108828:	83 ec 0c             	sub    $0xc,%esp
8010882b:	ff 75 e0             	pushl  -0x20(%ebp)
8010882e:	e8 6d f3 ff ff       	call   80107ba0 <v2p>
80108833:	83 c4 10             	add    $0x10,%esp
80108836:	89 c2                	mov    %eax,%edx
80108838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010883b:	83 ec 0c             	sub    $0xc,%esp
8010883e:	53                   	push   %ebx
8010883f:	52                   	push   %edx
80108840:	68 00 10 00 00       	push   $0x1000
80108845:	50                   	push   %eax
80108846:	ff 75 f0             	pushl  -0x10(%ebp)
80108849:	e8 81 f8 ff ff       	call   801080cf <mappages>
8010884e:	83 c4 20             	add    $0x20,%esp
80108851:	85 c0                	test   %eax,%eax
80108853:	78 1b                	js     80108870 <copyuvm+0x103>
  for(i = 0; i < sz; i += PGSIZE){
80108855:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010885c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010885f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108862:	0f 82 30 ff ff ff    	jb     80108798 <copyuvm+0x2b>
      goto bad;
  }
  return d;
80108868:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010886b:	eb 17                	jmp    80108884 <copyuvm+0x117>
      goto bad;
8010886d:	90                   	nop
8010886e:	eb 01                	jmp    80108871 <copyuvm+0x104>
      goto bad;
80108870:	90                   	nop

bad:
  freevm(d);
80108871:	83 ec 0c             	sub    $0xc,%esp
80108874:	ff 75 f0             	pushl  -0x10(%ebp)
80108877:	e8 10 fe ff ff       	call   8010868c <freevm>
8010887c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010887f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108887:	c9                   	leave  
80108888:	c3                   	ret    

80108889 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108889:	55                   	push   %ebp
8010888a:	89 e5                	mov    %esp,%ebp
8010888c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010888f:	83 ec 04             	sub    $0x4,%esp
80108892:	6a 00                	push   $0x0
80108894:	ff 75 0c             	pushl  0xc(%ebp)
80108897:	ff 75 08             	pushl  0x8(%ebp)
8010889a:	e8 90 f7 ff ff       	call   8010802f <walkpgdir>
8010889f:	83 c4 10             	add    $0x10,%esp
801088a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801088a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088a8:	8b 00                	mov    (%eax),%eax
801088aa:	83 e0 01             	and    $0x1,%eax
801088ad:	85 c0                	test   %eax,%eax
801088af:	75 07                	jne    801088b8 <uva2ka+0x2f>
    return 0;
801088b1:	b8 00 00 00 00       	mov    $0x0,%eax
801088b6:	eb 29                	jmp    801088e1 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801088b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088bb:	8b 00                	mov    (%eax),%eax
801088bd:	83 e0 04             	and    $0x4,%eax
801088c0:	85 c0                	test   %eax,%eax
801088c2:	75 07                	jne    801088cb <uva2ka+0x42>
    return 0;
801088c4:	b8 00 00 00 00       	mov    $0x0,%eax
801088c9:	eb 16                	jmp    801088e1 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
801088cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ce:	8b 00                	mov    (%eax),%eax
801088d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088d5:	83 ec 0c             	sub    $0xc,%esp
801088d8:	50                   	push   %eax
801088d9:	e8 cf f2 ff ff       	call   80107bad <p2v>
801088de:	83 c4 10             	add    $0x10,%esp
}
801088e1:	c9                   	leave  
801088e2:	c3                   	ret    

801088e3 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801088e3:	55                   	push   %ebp
801088e4:	89 e5                	mov    %esp,%ebp
801088e6:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801088e9:	8b 45 10             	mov    0x10(%ebp),%eax
801088ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801088ef:	eb 7f                	jmp    80108970 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801088f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801088f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801088fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088ff:	83 ec 08             	sub    $0x8,%esp
80108902:	50                   	push   %eax
80108903:	ff 75 08             	pushl  0x8(%ebp)
80108906:	e8 7e ff ff ff       	call   80108889 <uva2ka>
8010890b:	83 c4 10             	add    $0x10,%esp
8010890e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108911:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108915:	75 07                	jne    8010891e <copyout+0x3b>
      return -1;
80108917:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010891c:	eb 61                	jmp    8010897f <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010891e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108921:	2b 45 0c             	sub    0xc(%ebp),%eax
80108924:	05 00 10 00 00       	add    $0x1000,%eax
80108929:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010892c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010892f:	3b 45 14             	cmp    0x14(%ebp),%eax
80108932:	76 06                	jbe    8010893a <copyout+0x57>
      n = len;
80108934:	8b 45 14             	mov    0x14(%ebp),%eax
80108937:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010893a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010893d:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108940:	89 c2                	mov    %eax,%edx
80108942:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108945:	01 d0                	add    %edx,%eax
80108947:	83 ec 04             	sub    $0x4,%esp
8010894a:	ff 75 f0             	pushl  -0x10(%ebp)
8010894d:	ff 75 f4             	pushl  -0xc(%ebp)
80108950:	50                   	push   %eax
80108951:	e8 7a cb ff ff       	call   801054d0 <memmove>
80108956:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108959:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010895c:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010895f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108962:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108965:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108968:	05 00 10 00 00       	add    $0x1000,%eax
8010896d:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108970:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108974:	0f 85 77 ff ff ff    	jne    801088f1 <copyout+0xe>
  }
  return 0;
8010897a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010897f:	c9                   	leave  
80108980:	c3                   	ret    
