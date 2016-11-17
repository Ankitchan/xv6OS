
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 65 02 00 00       	call   27b <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 ef 02 00 00       	call   313 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 57 02 00 00       	call   283 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8d 50 01             	lea    0x1(%eax),%edx
  65:	89 55 08             	mov    %edx,0x8(%ebp)
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	pushl  0xc(%ebp)
  f2:	ff 75 08             	pushl  0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 47 01 00 00       	call   29b <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18f:	7c b3                	jl     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
      break;
 193:	90                   	nop
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <stat>:

int
stat(char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	pushl  0x8(%ebp)
 1b2:	e8 0c 01 00 00       	call   2c3 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	pushl  0xc(%ebp)
 1d0:	ff 75 f4             	pushl  -0xc(%ebp)
 1d3:	e8 03 01 00 00       	call   2db <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	pushl  -0xc(%ebp)
 1e4:	e8 c2 00 00 00       	call   2ab <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fe:	eb 25                	jmp    225 <atoi+0x34>
    n = n*10 + *s++ - '0';
 200:	8b 55 fc             	mov    -0x4(%ebp),%edx
 203:	89 d0                	mov    %edx,%eax
 205:	c1 e0 02             	shl    $0x2,%eax
 208:	01 d0                	add    %edx,%eax
 20a:	01 c0                	add    %eax,%eax
 20c:	89 c1                	mov    %eax,%ecx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8d 50 01             	lea    0x1(%eax),%edx
 214:	89 55 08             	mov    %edx,0x8(%ebp)
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	0f be c0             	movsbl %al,%eax
 21d:	01 c8                	add    %ecx,%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	3c 2f                	cmp    $0x2f,%al
 22d:	7e 0a                	jle    239 <atoi+0x48>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 39                	cmp    $0x39,%al
 237:	7e c7                	jle    200 <atoi+0xf>
  return n;
 239:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 250:	eb 17                	jmp    269 <memmove+0x2b>
    *dst++ = *src++;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
 255:	8d 50 01             	lea    0x1(%eax),%edx
 258:	89 55 fc             	mov    %edx,-0x4(%ebp)
 25b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 25e:	8d 4a 01             	lea    0x1(%edx),%ecx
 261:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 264:	0f b6 12             	movzbl (%edx),%edx
 267:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 269:	8b 45 10             	mov    0x10(%ebp),%eax
 26c:	8d 50 ff             	lea    -0x1(%eax),%edx
 26f:	89 55 10             	mov    %edx,0x10(%ebp)
 272:	85 c0                	test   %eax,%eax
 274:	7f dc                	jg     252 <memmove+0x14>
  return vdst;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27b:	b8 01 00 00 00       	mov    $0x1,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <exit>:
SYSCALL(exit)
 283:	b8 02 00 00 00       	mov    $0x2,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <wait>:
SYSCALL(wait)
 28b:	b8 03 00 00 00       	mov    $0x3,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <pipe>:
SYSCALL(pipe)
 293:	b8 04 00 00 00       	mov    $0x4,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <read>:
SYSCALL(read)
 29b:	b8 05 00 00 00       	mov    $0x5,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <write>:
SYSCALL(write)
 2a3:	b8 10 00 00 00       	mov    $0x10,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <close>:
SYSCALL(close)
 2ab:	b8 15 00 00 00       	mov    $0x15,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <kill>:
SYSCALL(kill)
 2b3:	b8 06 00 00 00       	mov    $0x6,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <exec>:
SYSCALL(exec)
 2bb:	b8 07 00 00 00       	mov    $0x7,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <open>:
SYSCALL(open)
 2c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <mknod>:
SYSCALL(mknod)
 2cb:	b8 11 00 00 00       	mov    $0x11,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <unlink>:
SYSCALL(unlink)
 2d3:	b8 12 00 00 00       	mov    $0x12,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <fstat>:
SYSCALL(fstat)
 2db:	b8 08 00 00 00       	mov    $0x8,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <link>:
SYSCALL(link)
 2e3:	b8 13 00 00 00       	mov    $0x13,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <mkdir>:
SYSCALL(mkdir)
 2eb:	b8 14 00 00 00       	mov    $0x14,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <chdir>:
SYSCALL(chdir)
 2f3:	b8 09 00 00 00       	mov    $0x9,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <dup>:
SYSCALL(dup)
 2fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <getpid>:
SYSCALL(getpid)
 303:	b8 0b 00 00 00       	mov    $0xb,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <sbrk>:
SYSCALL(sbrk)
 30b:	b8 0c 00 00 00       	mov    $0xc,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <sleep>:
SYSCALL(sleep)
 313:	b8 0d 00 00 00       	mov    $0xd,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <uptime>:
SYSCALL(uptime)
 31b:	b8 0e 00 00 00       	mov    $0xe,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <gettime>:
SYSCALL(gettime)
 323:	b8 16 00 00 00       	mov    $0x16,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <settickets>:
SYSCALL(settickets)
 32b:	b8 17 00 00 00       	mov    $0x17,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 333:	55                   	push   %ebp
 334:	89 e5                	mov    %esp,%ebp
 336:	83 ec 18             	sub    $0x18,%esp
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 33f:	83 ec 04             	sub    $0x4,%esp
 342:	6a 01                	push   $0x1
 344:	8d 45 f4             	lea    -0xc(%ebp),%eax
 347:	50                   	push   %eax
 348:	ff 75 08             	pushl  0x8(%ebp)
 34b:	e8 53 ff ff ff       	call   2a3 <write>
 350:	83 c4 10             	add    $0x10,%esp
}
 353:	90                   	nop
 354:	c9                   	leave  
 355:	c3                   	ret    

00000356 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	53                   	push   %ebx
 35a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 35d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 364:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 368:	74 17                	je     381 <printint+0x2b>
 36a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 36e:	79 11                	jns    381 <printint+0x2b>
    neg = 1;
 370:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 377:	8b 45 0c             	mov    0xc(%ebp),%eax
 37a:	f7 d8                	neg    %eax
 37c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 37f:	eb 06                	jmp    387 <printint+0x31>
  } else {
    x = xx;
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 38e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 391:	8d 41 01             	lea    0x1(%ecx),%eax
 394:	89 45 f4             	mov    %eax,-0xc(%ebp)
 397:	8b 5d 10             	mov    0x10(%ebp),%ebx
 39a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 39d:	ba 00 00 00 00       	mov    $0x0,%edx
 3a2:	f7 f3                	div    %ebx
 3a4:	89 d0                	mov    %edx,%eax
 3a6:	0f b6 80 b4 0a 00 00 	movzbl 0xab4(%eax),%eax
 3ad:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b7:	ba 00 00 00 00       	mov    $0x0,%edx
 3bc:	f7 f3                	div    %ebx
 3be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c5:	75 c7                	jne    38e <printint+0x38>
  if(neg)
 3c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3cb:	74 2d                	je     3fa <printint+0xa4>
    buf[i++] = '-';
 3cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d0:	8d 50 01             	lea    0x1(%eax),%edx
 3d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3d6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3db:	eb 1d                	jmp    3fa <printint+0xa4>
    putc(fd, buf[i]);
 3dd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e3:	01 d0                	add    %edx,%eax
 3e5:	0f b6 00             	movzbl (%eax),%eax
 3e8:	0f be c0             	movsbl %al,%eax
 3eb:	83 ec 08             	sub    $0x8,%esp
 3ee:	50                   	push   %eax
 3ef:	ff 75 08             	pushl  0x8(%ebp)
 3f2:	e8 3c ff ff ff       	call   333 <putc>
 3f7:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 3fa:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 3fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 402:	79 d9                	jns    3dd <printint+0x87>
}
 404:	90                   	nop
 405:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 408:	c9                   	leave  
 409:	c3                   	ret    

0000040a <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 40a:	55                   	push   %ebp
 40b:	89 e5                	mov    %esp,%ebp
 40d:	83 ec 28             	sub    $0x28,%esp
 410:	8b 45 0c             	mov    0xc(%ebp),%eax
 413:	89 45 e0             	mov    %eax,-0x20(%ebp)
 416:	8b 45 10             	mov    0x10(%ebp),%eax
 419:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 41c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 41f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 422:	89 d0                	mov    %edx,%eax
 424:	31 d2                	xor    %edx,%edx
 426:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 429:	8b 45 e0             	mov    -0x20(%ebp),%eax
 42c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 42f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 433:	74 13                	je     448 <printlong+0x3e>
 435:	8b 45 f4             	mov    -0xc(%ebp),%eax
 438:	6a 00                	push   $0x0
 43a:	6a 10                	push   $0x10
 43c:	50                   	push   %eax
 43d:	ff 75 08             	pushl  0x8(%ebp)
 440:	e8 11 ff ff ff       	call   356 <printint>
 445:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 448:	8b 45 f0             	mov    -0x10(%ebp),%eax
 44b:	6a 00                	push   $0x0
 44d:	6a 10                	push   $0x10
 44f:	50                   	push   %eax
 450:	ff 75 08             	pushl  0x8(%ebp)
 453:	e8 fe fe ff ff       	call   356 <printint>
 458:	83 c4 10             	add    $0x10,%esp
}
 45b:	90                   	nop
 45c:	c9                   	leave  
 45d:	c3                   	ret    

0000045e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 45e:	55                   	push   %ebp
 45f:	89 e5                	mov    %esp,%ebp
 461:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 464:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46b:	8d 45 0c             	lea    0xc(%ebp),%eax
 46e:	83 c0 04             	add    $0x4,%eax
 471:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 474:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47b:	e9 88 01 00 00       	jmp    608 <printf+0x1aa>
    c = fmt[i] & 0xff;
 480:	8b 55 0c             	mov    0xc(%ebp),%edx
 483:	8b 45 f0             	mov    -0x10(%ebp),%eax
 486:	01 d0                	add    %edx,%eax
 488:	0f b6 00             	movzbl (%eax),%eax
 48b:	0f be c0             	movsbl %al,%eax
 48e:	25 ff 00 00 00       	and    $0xff,%eax
 493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 496:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49a:	75 2c                	jne    4c8 <printf+0x6a>
      if(c == '%'){
 49c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a0:	75 0c                	jne    4ae <printf+0x50>
        state = '%';
 4a2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a9:	e9 56 01 00 00       	jmp    604 <printf+0x1a6>
      } else {
        putc(fd, c);
 4ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b1:	0f be c0             	movsbl %al,%eax
 4b4:	83 ec 08             	sub    $0x8,%esp
 4b7:	50                   	push   %eax
 4b8:	ff 75 08             	pushl  0x8(%ebp)
 4bb:	e8 73 fe ff ff       	call   333 <putc>
 4c0:	83 c4 10             	add    $0x10,%esp
 4c3:	e9 3c 01 00 00       	jmp    604 <printf+0x1a6>
      }
    } else if(state == '%'){
 4c8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4cc:	0f 85 32 01 00 00    	jne    604 <printf+0x1a6>
      if(c == 'd'){
 4d2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d6:	75 1e                	jne    4f6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4db:	8b 00                	mov    (%eax),%eax
 4dd:	6a 01                	push   $0x1
 4df:	6a 0a                	push   $0xa
 4e1:	50                   	push   %eax
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	e8 6c fe ff ff       	call   356 <printint>
 4ea:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f1:	e9 07 01 00 00       	jmp    5fd <printf+0x19f>
      } else if(c == 'l') {
 4f6:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 4fa:	75 29                	jne    525 <printf+0xc7>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 4fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ff:	8b 50 04             	mov    0x4(%eax),%edx
 502:	8b 00                	mov    (%eax),%eax
 504:	83 ec 0c             	sub    $0xc,%esp
 507:	6a 00                	push   $0x0
 509:	6a 0a                	push   $0xa
 50b:	52                   	push   %edx
 50c:	50                   	push   %eax
 50d:	ff 75 08             	pushl  0x8(%ebp)
 510:	e8 f5 fe ff ff       	call   40a <printlong>
 515:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 518:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 51c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 520:	e9 d8 00 00 00       	jmp    5fd <printf+0x19f>
      } else if(c == 'x' || c == 'p'){
 525:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 529:	74 06                	je     531 <printf+0xd3>
 52b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52f:	75 1e                	jne    54f <printf+0xf1>
        printint(fd, *ap, 16, 0);
 531:	8b 45 e8             	mov    -0x18(%ebp),%eax
 534:	8b 00                	mov    (%eax),%eax
 536:	6a 00                	push   $0x0
 538:	6a 10                	push   $0x10
 53a:	50                   	push   %eax
 53b:	ff 75 08             	pushl  0x8(%ebp)
 53e:	e8 13 fe ff ff       	call   356 <printint>
 543:	83 c4 10             	add    $0x10,%esp
        ap++;
 546:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54a:	e9 ae 00 00 00       	jmp    5fd <printf+0x19f>
      } else if(c == 's'){
 54f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 553:	75 43                	jne    598 <printf+0x13a>
        s = (char*)*ap;
 555:	8b 45 e8             	mov    -0x18(%ebp),%eax
 558:	8b 00                	mov    (%eax),%eax
 55a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 565:	75 25                	jne    58c <printf+0x12e>
          s = "(null)";
 567:	c7 45 f4 43 08 00 00 	movl   $0x843,-0xc(%ebp)
        while(*s != 0){
 56e:	eb 1c                	jmp    58c <printf+0x12e>
          putc(fd, *s);
 570:	8b 45 f4             	mov    -0xc(%ebp),%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	0f be c0             	movsbl %al,%eax
 579:	83 ec 08             	sub    $0x8,%esp
 57c:	50                   	push   %eax
 57d:	ff 75 08             	pushl  0x8(%ebp)
 580:	e8 ae fd ff ff       	call   333 <putc>
 585:	83 c4 10             	add    $0x10,%esp
          s++;
 588:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 58c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58f:	0f b6 00             	movzbl (%eax),%eax
 592:	84 c0                	test   %al,%al
 594:	75 da                	jne    570 <printf+0x112>
 596:	eb 65                	jmp    5fd <printf+0x19f>
        }
      } else if(c == 'c'){
 598:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59c:	75 1d                	jne    5bb <printf+0x15d>
        putc(fd, *ap);
 59e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a1:	8b 00                	mov    (%eax),%eax
 5a3:	0f be c0             	movsbl %al,%eax
 5a6:	83 ec 08             	sub    $0x8,%esp
 5a9:	50                   	push   %eax
 5aa:	ff 75 08             	pushl  0x8(%ebp)
 5ad:	e8 81 fd ff ff       	call   333 <putc>
 5b2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b9:	eb 42                	jmp    5fd <printf+0x19f>
      } else if(c == '%'){
 5bb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5bf:	75 17                	jne    5d8 <printf+0x17a>
        putc(fd, c);
 5c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c4:	0f be c0             	movsbl %al,%eax
 5c7:	83 ec 08             	sub    $0x8,%esp
 5ca:	50                   	push   %eax
 5cb:	ff 75 08             	pushl  0x8(%ebp)
 5ce:	e8 60 fd ff ff       	call   333 <putc>
 5d3:	83 c4 10             	add    $0x10,%esp
 5d6:	eb 25                	jmp    5fd <printf+0x19f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d8:	83 ec 08             	sub    $0x8,%esp
 5db:	6a 25                	push   $0x25
 5dd:	ff 75 08             	pushl  0x8(%ebp)
 5e0:	e8 4e fd ff ff       	call   333 <putc>
 5e5:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5eb:	0f be c0             	movsbl %al,%eax
 5ee:	83 ec 08             	sub    $0x8,%esp
 5f1:	50                   	push   %eax
 5f2:	ff 75 08             	pushl  0x8(%ebp)
 5f5:	e8 39 fd ff ff       	call   333 <putc>
 5fa:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 604:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 608:	8b 55 0c             	mov    0xc(%ebp),%edx
 60b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60e:	01 d0                	add    %edx,%eax
 610:	0f b6 00             	movzbl (%eax),%eax
 613:	84 c0                	test   %al,%al
 615:	0f 85 65 fe ff ff    	jne    480 <printf+0x22>
    }
  }
}
 61b:	90                   	nop
 61c:	c9                   	leave  
 61d:	c3                   	ret    

0000061e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61e:	55                   	push   %ebp
 61f:	89 e5                	mov    %esp,%ebp
 621:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 624:	8b 45 08             	mov    0x8(%ebp),%eax
 627:	83 e8 08             	sub    $0x8,%eax
 62a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62d:	a1 d0 0a 00 00       	mov    0xad0,%eax
 632:	89 45 fc             	mov    %eax,-0x4(%ebp)
 635:	eb 24                	jmp    65b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 637:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63f:	77 12                	ja     653 <free+0x35>
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 647:	77 24                	ja     66d <free+0x4f>
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 651:	77 1a                	ja     66d <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 653:	8b 45 fc             	mov    -0x4(%ebp),%eax
 656:	8b 00                	mov    (%eax),%eax
 658:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 661:	76 d4                	jbe    637 <free+0x19>
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66b:	76 ca                	jbe    637 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 66d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 670:	8b 40 04             	mov    0x4(%eax),%eax
 673:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	01 c2                	add    %eax,%edx
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	39 c2                	cmp    %eax,%edx
 686:	75 24                	jne    6ac <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	8b 50 04             	mov    0x4(%eax),%edx
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 00                	mov    (%eax),%eax
 693:	8b 40 04             	mov    0x4(%eax),%eax
 696:	01 c2                	add    %eax,%edx
 698:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	8b 10                	mov    (%eax),%edx
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	89 10                	mov    %edx,(%eax)
 6aa:	eb 0a                	jmp    6b6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 10                	mov    (%eax),%edx
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 40 04             	mov    0x4(%eax),%eax
 6bc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	01 d0                	add    %edx,%eax
 6c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6cb:	75 20                	jne    6ed <free+0xcf>
    p->s.size += bp->s.size;
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 50 04             	mov    0x4(%eax),%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	8b 40 04             	mov    0x4(%eax),%eax
 6d9:	01 c2                	add    %eax,%edx
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	8b 10                	mov    (%eax),%edx
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	89 10                	mov    %edx,(%eax)
 6eb:	eb 08                	jmp    6f5 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f3:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	a3 d0 0a 00 00       	mov    %eax,0xad0
}
 6fd:	90                   	nop
 6fe:	c9                   	leave  
 6ff:	c3                   	ret    

00000700 <morecore>:

static Header*
morecore(uint nu)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 706:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70d:	77 07                	ja     716 <morecore+0x16>
    nu = 4096;
 70f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 716:	8b 45 08             	mov    0x8(%ebp),%eax
 719:	c1 e0 03             	shl    $0x3,%eax
 71c:	83 ec 0c             	sub    $0xc,%esp
 71f:	50                   	push   %eax
 720:	e8 e6 fb ff ff       	call   30b <sbrk>
 725:	83 c4 10             	add    $0x10,%esp
 728:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 72b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72f:	75 07                	jne    738 <morecore+0x38>
    return 0;
 731:	b8 00 00 00 00       	mov    $0x0,%eax
 736:	eb 26                	jmp    75e <morecore+0x5e>
  hp = (Header*)p;
 738:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 741:	8b 55 08             	mov    0x8(%ebp),%edx
 744:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 747:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74a:	83 c0 08             	add    $0x8,%eax
 74d:	83 ec 0c             	sub    $0xc,%esp
 750:	50                   	push   %eax
 751:	e8 c8 fe ff ff       	call   61e <free>
 756:	83 c4 10             	add    $0x10,%esp
  return freep;
 759:	a1 d0 0a 00 00       	mov    0xad0,%eax
}
 75e:	c9                   	leave  
 75f:	c3                   	ret    

00000760 <malloc>:

void*
malloc(uint nbytes)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 766:	8b 45 08             	mov    0x8(%ebp),%eax
 769:	83 c0 07             	add    $0x7,%eax
 76c:	c1 e8 03             	shr    $0x3,%eax
 76f:	83 c0 01             	add    $0x1,%eax
 772:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 775:	a1 d0 0a 00 00       	mov    0xad0,%eax
 77a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 781:	75 23                	jne    7a6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 783:	c7 45 f0 c8 0a 00 00 	movl   $0xac8,-0x10(%ebp)
 78a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78d:	a3 d0 0a 00 00       	mov    %eax,0xad0
 792:	a1 d0 0a 00 00       	mov    0xad0,%eax
 797:	a3 c8 0a 00 00       	mov    %eax,0xac8
    base.s.size = 0;
 79c:	c7 05 cc 0a 00 00 00 	movl   $0x0,0xacc
 7a3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	8b 00                	mov    (%eax),%eax
 7ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	8b 40 04             	mov    0x4(%eax),%eax
 7b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b7:	72 4d                	jb     806 <malloc+0xa6>
      if(p->s.size == nunits)
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	8b 40 04             	mov    0x4(%eax),%eax
 7bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c2:	75 0c                	jne    7d0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 10                	mov    (%eax),%edx
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	89 10                	mov    %edx,(%eax)
 7ce:	eb 26                	jmp    7f6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	8b 40 04             	mov    0x4(%eax),%eax
 7d6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d9:	89 c2                	mov    %eax,%edx
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 40 04             	mov    0x4(%eax),%eax
 7e7:	c1 e0 03             	shl    $0x3,%eax
 7ea:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f9:	a3 d0 0a 00 00       	mov    %eax,0xad0
      return (void*)(p + 1);
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	83 c0 08             	add    $0x8,%eax
 804:	eb 3b                	jmp    841 <malloc+0xe1>
    }
    if(p == freep)
 806:	a1 d0 0a 00 00       	mov    0xad0,%eax
 80b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80e:	75 1e                	jne    82e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 810:	83 ec 0c             	sub    $0xc,%esp
 813:	ff 75 ec             	pushl  -0x14(%ebp)
 816:	e8 e5 fe ff ff       	call   700 <morecore>
 81b:	83 c4 10             	add    $0x10,%esp
 81e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 825:	75 07                	jne    82e <malloc+0xce>
        return 0;
 827:	b8 00 00 00 00       	mov    $0x0,%eax
 82c:	eb 13                	jmp    841 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	89 45 f0             	mov    %eax,-0x10(%ebp)
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8b 00                	mov    (%eax),%eax
 839:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 83c:	e9 6d ff ff ff       	jmp    7ae <malloc+0x4e>
  }
}
 841:	c9                   	leave  
 842:	c3                   	ret    
