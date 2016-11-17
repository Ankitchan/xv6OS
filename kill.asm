
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 89 08 00 00       	push   $0x889
  21:	6a 02                	push   $0x2
  23:	e8 7c 04 00 00       	call   4a4 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 99 02 00 00       	call   2c9 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 9a 02 00 00       	call   2f9 <kill>
  5f:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
  exit();
  6d:	e8 57 02 00 00       	call   2c9 <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	8d 50 01             	lea    0x1(%eax),%edx
  ab:	89 55 08             	mov    %edx,0x8(%ebp)
  ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  b4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	pushl  0xc(%ebp)
 138:	ff 75 08             	pushl  0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 47 01 00 00       	call   2e1 <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d5:	7c b3                	jl     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
      break;
 1d9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	pushl  0x8(%ebp)
 1f8:	e8 0c 01 00 00       	call   309 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 f4             	pushl  -0xc(%ebp)
 219:	e8 03 01 00 00       	call   321 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 c2 00 00 00       	call   2f1 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29b:	8d 50 01             	lea    0x1(%eax),%edx
 29e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c1:	b8 01 00 00 00       	mov    $0x1,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <exit>:
SYSCALL(exit)
 2c9:	b8 02 00 00 00       	mov    $0x2,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <wait>:
SYSCALL(wait)
 2d1:	b8 03 00 00 00       	mov    $0x3,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <pipe>:
SYSCALL(pipe)
 2d9:	b8 04 00 00 00       	mov    $0x4,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <read>:
SYSCALL(read)
 2e1:	b8 05 00 00 00       	mov    $0x5,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <write>:
SYSCALL(write)
 2e9:	b8 10 00 00 00       	mov    $0x10,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <close>:
SYSCALL(close)
 2f1:	b8 15 00 00 00       	mov    $0x15,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <kill>:
SYSCALL(kill)
 2f9:	b8 06 00 00 00       	mov    $0x6,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <exec>:
SYSCALL(exec)
 301:	b8 07 00 00 00       	mov    $0x7,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <open>:
SYSCALL(open)
 309:	b8 0f 00 00 00       	mov    $0xf,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <mknod>:
SYSCALL(mknod)
 311:	b8 11 00 00 00       	mov    $0x11,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <unlink>:
SYSCALL(unlink)
 319:	b8 12 00 00 00       	mov    $0x12,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <fstat>:
SYSCALL(fstat)
 321:	b8 08 00 00 00       	mov    $0x8,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <link>:
SYSCALL(link)
 329:	b8 13 00 00 00       	mov    $0x13,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <mkdir>:
SYSCALL(mkdir)
 331:	b8 14 00 00 00       	mov    $0x14,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <chdir>:
SYSCALL(chdir)
 339:	b8 09 00 00 00       	mov    $0x9,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <dup>:
SYSCALL(dup)
 341:	b8 0a 00 00 00       	mov    $0xa,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <getpid>:
SYSCALL(getpid)
 349:	b8 0b 00 00 00       	mov    $0xb,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <sbrk>:
SYSCALL(sbrk)
 351:	b8 0c 00 00 00       	mov    $0xc,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <sleep>:
SYSCALL(sleep)
 359:	b8 0d 00 00 00       	mov    $0xd,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <uptime>:
SYSCALL(uptime)
 361:	b8 0e 00 00 00       	mov    $0xe,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <gettime>:
SYSCALL(gettime)
 369:	b8 16 00 00 00       	mov    $0x16,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <settickets>:
SYSCALL(settickets)
 371:	b8 17 00 00 00       	mov    $0x17,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	83 ec 18             	sub    $0x18,%esp
 37f:	8b 45 0c             	mov    0xc(%ebp),%eax
 382:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 385:	83 ec 04             	sub    $0x4,%esp
 388:	6a 01                	push   $0x1
 38a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38d:	50                   	push   %eax
 38e:	ff 75 08             	pushl  0x8(%ebp)
 391:	e8 53 ff ff ff       	call   2e9 <write>
 396:	83 c4 10             	add    $0x10,%esp
}
 399:	90                   	nop
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	53                   	push   %ebx
 3a0:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3aa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ae:	74 17                	je     3c7 <printint+0x2b>
 3b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b4:	79 11                	jns    3c7 <printint+0x2b>
    neg = 1;
 3b6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c0:	f7 d8                	neg    %eax
 3c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c5:	eb 06                	jmp    3cd <printint+0x31>
  } else {
    x = xx;
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3d7:	8d 41 01             	lea    0x1(%ecx),%eax
 3da:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e3:	ba 00 00 00 00       	mov    $0x0,%edx
 3e8:	f7 f3                	div    %ebx
 3ea:	89 d0                	mov    %edx,%eax
 3ec:	0f b6 80 10 0b 00 00 	movzbl 0xb10(%eax),%eax
 3f3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fd:	ba 00 00 00 00       	mov    $0x0,%edx
 402:	f7 f3                	div    %ebx
 404:	89 45 ec             	mov    %eax,-0x14(%ebp)
 407:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40b:	75 c7                	jne    3d4 <printint+0x38>
  if(neg)
 40d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 411:	74 2d                	je     440 <printint+0xa4>
    buf[i++] = '-';
 413:	8b 45 f4             	mov    -0xc(%ebp),%eax
 416:	8d 50 01             	lea    0x1(%eax),%edx
 419:	89 55 f4             	mov    %edx,-0xc(%ebp)
 41c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 421:	eb 1d                	jmp    440 <printint+0xa4>
    putc(fd, buf[i]);
 423:	8d 55 dc             	lea    -0x24(%ebp),%edx
 426:	8b 45 f4             	mov    -0xc(%ebp),%eax
 429:	01 d0                	add    %edx,%eax
 42b:	0f b6 00             	movzbl (%eax),%eax
 42e:	0f be c0             	movsbl %al,%eax
 431:	83 ec 08             	sub    $0x8,%esp
 434:	50                   	push   %eax
 435:	ff 75 08             	pushl  0x8(%ebp)
 438:	e8 3c ff ff ff       	call   379 <putc>
 43d:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 440:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 448:	79 d9                	jns    423 <printint+0x87>
}
 44a:	90                   	nop
 44b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 44e:	c9                   	leave  
 44f:	c3                   	ret    

00000450 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	83 ec 28             	sub    $0x28,%esp
 456:	8b 45 0c             	mov    0xc(%ebp),%eax
 459:	89 45 e0             	mov    %eax,-0x20(%ebp)
 45c:	8b 45 10             	mov    0x10(%ebp),%eax
 45f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 462:	8b 45 e0             	mov    -0x20(%ebp),%eax
 465:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 468:	89 d0                	mov    %edx,%eax
 46a:	31 d2                	xor    %edx,%edx
 46c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 46f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 472:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 475:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 479:	74 13                	je     48e <printlong+0x3e>
 47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47e:	6a 00                	push   $0x0
 480:	6a 10                	push   $0x10
 482:	50                   	push   %eax
 483:	ff 75 08             	pushl  0x8(%ebp)
 486:	e8 11 ff ff ff       	call   39c <printint>
 48b:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 48e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 491:	6a 00                	push   $0x0
 493:	6a 10                	push   $0x10
 495:	50                   	push   %eax
 496:	ff 75 08             	pushl  0x8(%ebp)
 499:	e8 fe fe ff ff       	call   39c <printint>
 49e:	83 c4 10             	add    $0x10,%esp
}
 4a1:	90                   	nop
 4a2:	c9                   	leave  
 4a3:	c3                   	ret    

000004a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b1:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b4:	83 c0 04             	add    $0x4,%eax
 4b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c1:	e9 88 01 00 00       	jmp    64e <printf+0x1aa>
    c = fmt[i] & 0xff;
 4c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4cc:	01 d0                	add    %edx,%eax
 4ce:	0f b6 00             	movzbl (%eax),%eax
 4d1:	0f be c0             	movsbl %al,%eax
 4d4:	25 ff 00 00 00       	and    $0xff,%eax
 4d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e0:	75 2c                	jne    50e <printf+0x6a>
      if(c == '%'){
 4e2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e6:	75 0c                	jne    4f4 <printf+0x50>
        state = '%';
 4e8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ef:	e9 56 01 00 00       	jmp    64a <printf+0x1a6>
      } else {
        putc(fd, c);
 4f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f7:	0f be c0             	movsbl %al,%eax
 4fa:	83 ec 08             	sub    $0x8,%esp
 4fd:	50                   	push   %eax
 4fe:	ff 75 08             	pushl  0x8(%ebp)
 501:	e8 73 fe ff ff       	call   379 <putc>
 506:	83 c4 10             	add    $0x10,%esp
 509:	e9 3c 01 00 00       	jmp    64a <printf+0x1a6>
      }
    } else if(state == '%'){
 50e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 512:	0f 85 32 01 00 00    	jne    64a <printf+0x1a6>
      if(c == 'd'){
 518:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51c:	75 1e                	jne    53c <printf+0x98>
        printint(fd, *ap, 10, 1);
 51e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 521:	8b 00                	mov    (%eax),%eax
 523:	6a 01                	push   $0x1
 525:	6a 0a                	push   $0xa
 527:	50                   	push   %eax
 528:	ff 75 08             	pushl  0x8(%ebp)
 52b:	e8 6c fe ff ff       	call   39c <printint>
 530:	83 c4 10             	add    $0x10,%esp
        ap++;
 533:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 537:	e9 07 01 00 00       	jmp    643 <printf+0x19f>
      } else if(c == 'l') {
 53c:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 540:	75 29                	jne    56b <printf+0xc7>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 542:	8b 45 e8             	mov    -0x18(%ebp),%eax
 545:	8b 50 04             	mov    0x4(%eax),%edx
 548:	8b 00                	mov    (%eax),%eax
 54a:	83 ec 0c             	sub    $0xc,%esp
 54d:	6a 00                	push   $0x0
 54f:	6a 0a                	push   $0xa
 551:	52                   	push   %edx
 552:	50                   	push   %eax
 553:	ff 75 08             	pushl  0x8(%ebp)
 556:	e8 f5 fe ff ff       	call   450 <printlong>
 55b:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 55e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 562:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 566:	e9 d8 00 00 00       	jmp    643 <printf+0x19f>
      } else if(c == 'x' || c == 'p'){
 56b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 56f:	74 06                	je     577 <printf+0xd3>
 571:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 575:	75 1e                	jne    595 <printf+0xf1>
        printint(fd, *ap, 16, 0);
 577:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57a:	8b 00                	mov    (%eax),%eax
 57c:	6a 00                	push   $0x0
 57e:	6a 10                	push   $0x10
 580:	50                   	push   %eax
 581:	ff 75 08             	pushl  0x8(%ebp)
 584:	e8 13 fe ff ff       	call   39c <printint>
 589:	83 c4 10             	add    $0x10,%esp
        ap++;
 58c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 590:	e9 ae 00 00 00       	jmp    643 <printf+0x19f>
      } else if(c == 's'){
 595:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 599:	75 43                	jne    5de <printf+0x13a>
        s = (char*)*ap;
 59b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59e:	8b 00                	mov    (%eax),%eax
 5a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ab:	75 25                	jne    5d2 <printf+0x12e>
          s = "(null)";
 5ad:	c7 45 f4 9d 08 00 00 	movl   $0x89d,-0xc(%ebp)
        while(*s != 0){
 5b4:	eb 1c                	jmp    5d2 <printf+0x12e>
          putc(fd, *s);
 5b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b9:	0f b6 00             	movzbl (%eax),%eax
 5bc:	0f be c0             	movsbl %al,%eax
 5bf:	83 ec 08             	sub    $0x8,%esp
 5c2:	50                   	push   %eax
 5c3:	ff 75 08             	pushl  0x8(%ebp)
 5c6:	e8 ae fd ff ff       	call   379 <putc>
 5cb:	83 c4 10             	add    $0x10,%esp
          s++;
 5ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d5:	0f b6 00             	movzbl (%eax),%eax
 5d8:	84 c0                	test   %al,%al
 5da:	75 da                	jne    5b6 <printf+0x112>
 5dc:	eb 65                	jmp    643 <printf+0x19f>
        }
      } else if(c == 'c'){
 5de:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e2:	75 1d                	jne    601 <printf+0x15d>
        putc(fd, *ap);
 5e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e7:	8b 00                	mov    (%eax),%eax
 5e9:	0f be c0             	movsbl %al,%eax
 5ec:	83 ec 08             	sub    $0x8,%esp
 5ef:	50                   	push   %eax
 5f0:	ff 75 08             	pushl  0x8(%ebp)
 5f3:	e8 81 fd ff ff       	call   379 <putc>
 5f8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ff:	eb 42                	jmp    643 <printf+0x19f>
      } else if(c == '%'){
 601:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 605:	75 17                	jne    61e <printf+0x17a>
        putc(fd, c);
 607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60a:	0f be c0             	movsbl %al,%eax
 60d:	83 ec 08             	sub    $0x8,%esp
 610:	50                   	push   %eax
 611:	ff 75 08             	pushl  0x8(%ebp)
 614:	e8 60 fd ff ff       	call   379 <putc>
 619:	83 c4 10             	add    $0x10,%esp
 61c:	eb 25                	jmp    643 <printf+0x19f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61e:	83 ec 08             	sub    $0x8,%esp
 621:	6a 25                	push   $0x25
 623:	ff 75 08             	pushl  0x8(%ebp)
 626:	e8 4e fd ff ff       	call   379 <putc>
 62b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 62e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 631:	0f be c0             	movsbl %al,%eax
 634:	83 ec 08             	sub    $0x8,%esp
 637:	50                   	push   %eax
 638:	ff 75 08             	pushl  0x8(%ebp)
 63b:	e8 39 fd ff ff       	call   379 <putc>
 640:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 643:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 64a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 64e:	8b 55 0c             	mov    0xc(%ebp),%edx
 651:	8b 45 f0             	mov    -0x10(%ebp),%eax
 654:	01 d0                	add    %edx,%eax
 656:	0f b6 00             	movzbl (%eax),%eax
 659:	84 c0                	test   %al,%al
 65b:	0f 85 65 fe ff ff    	jne    4c6 <printf+0x22>
    }
  }
}
 661:	90                   	nop
 662:	c9                   	leave  
 663:	c3                   	ret    

00000664 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 664:	55                   	push   %ebp
 665:	89 e5                	mov    %esp,%ebp
 667:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	83 e8 08             	sub    $0x8,%eax
 670:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 673:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 678:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67b:	eb 24                	jmp    6a1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 685:	77 12                	ja     699 <free+0x35>
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68d:	77 24                	ja     6b3 <free+0x4f>
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 697:	77 1a                	ja     6b3 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a7:	76 d4                	jbe    67d <free+0x19>
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b1:	76 ca                	jbe    67d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	8b 40 04             	mov    0x4(%eax),%eax
 6b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c3:	01 c2                	add    %eax,%edx
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	39 c2                	cmp    %eax,%edx
 6cc:	75 24                	jne    6f2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	8b 50 04             	mov    0x4(%eax),%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	8b 40 04             	mov    0x4(%eax),%eax
 6dc:	01 c2                	add    %eax,%edx
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	8b 10                	mov    (%eax),%edx
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	89 10                	mov    %edx,(%eax)
 6f0:	eb 0a                	jmp    6fc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 10                	mov    (%eax),%edx
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 40 04             	mov    0x4(%eax),%eax
 702:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	01 d0                	add    %edx,%eax
 70e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 711:	75 20                	jne    733 <free+0xcf>
    p->s.size += bp->s.size;
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	8b 50 04             	mov    0x4(%eax),%edx
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	8b 40 04             	mov    0x4(%eax),%eax
 71f:	01 c2                	add    %eax,%edx
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	8b 10                	mov    (%eax),%edx
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	89 10                	mov    %edx,(%eax)
 731:	eb 08                	jmp    73b <free+0xd7>
  } else
    p->s.ptr = bp;
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 55 f8             	mov    -0x8(%ebp),%edx
 739:	89 10                	mov    %edx,(%eax)
  freep = p;
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	a3 2c 0b 00 00       	mov    %eax,0xb2c
}
 743:	90                   	nop
 744:	c9                   	leave  
 745:	c3                   	ret    

00000746 <morecore>:

static Header*
morecore(uint nu)
{
 746:	55                   	push   %ebp
 747:	89 e5                	mov    %esp,%ebp
 749:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 753:	77 07                	ja     75c <morecore+0x16>
    nu = 4096;
 755:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75c:	8b 45 08             	mov    0x8(%ebp),%eax
 75f:	c1 e0 03             	shl    $0x3,%eax
 762:	83 ec 0c             	sub    $0xc,%esp
 765:	50                   	push   %eax
 766:	e8 e6 fb ff ff       	call   351 <sbrk>
 76b:	83 c4 10             	add    $0x10,%esp
 76e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 771:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 775:	75 07                	jne    77e <morecore+0x38>
    return 0;
 777:	b8 00 00 00 00       	mov    $0x0,%eax
 77c:	eb 26                	jmp    7a4 <morecore+0x5e>
  hp = (Header*)p;
 77e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 781:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 784:	8b 45 f0             	mov    -0x10(%ebp),%eax
 787:	8b 55 08             	mov    0x8(%ebp),%edx
 78a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 790:	83 c0 08             	add    $0x8,%eax
 793:	83 ec 0c             	sub    $0xc,%esp
 796:	50                   	push   %eax
 797:	e8 c8 fe ff ff       	call   664 <free>
 79c:	83 c4 10             	add    $0x10,%esp
  return freep;
 79f:	a1 2c 0b 00 00       	mov    0xb2c,%eax
}
 7a4:	c9                   	leave  
 7a5:	c3                   	ret    

000007a6 <malloc>:

void*
malloc(uint nbytes)
{
 7a6:	55                   	push   %ebp
 7a7:	89 e5                	mov    %esp,%ebp
 7a9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	83 c0 07             	add    $0x7,%eax
 7b2:	c1 e8 03             	shr    $0x3,%eax
 7b5:	83 c0 01             	add    $0x1,%eax
 7b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7bb:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 7c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c7:	75 23                	jne    7ec <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7c9:	c7 45 f0 24 0b 00 00 	movl   $0xb24,-0x10(%ebp)
 7d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d3:	a3 2c 0b 00 00       	mov    %eax,0xb2c
 7d8:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 7dd:	a3 24 0b 00 00       	mov    %eax,0xb24
    base.s.size = 0;
 7e2:	c7 05 28 0b 00 00 00 	movl   $0x0,0xb28
 7e9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ef:	8b 00                	mov    (%eax),%eax
 7f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	8b 40 04             	mov    0x4(%eax),%eax
 7fa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fd:	72 4d                	jb     84c <malloc+0xa6>
      if(p->s.size == nunits)
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	8b 40 04             	mov    0x4(%eax),%eax
 805:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 808:	75 0c                	jne    816 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	8b 10                	mov    (%eax),%edx
 80f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 812:	89 10                	mov    %edx,(%eax)
 814:	eb 26                	jmp    83c <malloc+0x96>
      else {
        p->s.size -= nunits;
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	8b 40 04             	mov    0x4(%eax),%eax
 81c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 81f:	89 c2                	mov    %eax,%edx
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	8b 40 04             	mov    0x4(%eax),%eax
 82d:	c1 e0 03             	shl    $0x3,%eax
 830:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8b 55 ec             	mov    -0x14(%ebp),%edx
 839:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	a3 2c 0b 00 00       	mov    %eax,0xb2c
      return (void*)(p + 1);
 844:	8b 45 f4             	mov    -0xc(%ebp),%eax
 847:	83 c0 08             	add    $0x8,%eax
 84a:	eb 3b                	jmp    887 <malloc+0xe1>
    }
    if(p == freep)
 84c:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 851:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 854:	75 1e                	jne    874 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 856:	83 ec 0c             	sub    $0xc,%esp
 859:	ff 75 ec             	pushl  -0x14(%ebp)
 85c:	e8 e5 fe ff ff       	call   746 <morecore>
 861:	83 c4 10             	add    $0x10,%esp
 864:	89 45 f4             	mov    %eax,-0xc(%ebp)
 867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86b:	75 07                	jne    874 <malloc+0xce>
        return 0;
 86d:	b8 00 00 00 00       	mov    $0x0,%eax
 872:	eb 13                	jmp    887 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	8b 00                	mov    (%eax),%eax
 87f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 882:	e9 6d ff ff ff       	jmp    7f4 <malloc+0x4e>
  }
}
 887:	c9                   	leave  
 888:	c3                   	ret    
