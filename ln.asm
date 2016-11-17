
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 8b 08 00 00       	push   $0x88b
  1e:	6a 02                	push   $0x2
  20:	e8 81 04 00 00       	call   4a6 <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 9e 02 00 00       	call   2cb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 e4 02 00 00       	call   32b <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 9e 08 00 00       	push   $0x89e
  65:	6a 02                	push   $0x2
  67:	e8 3a 04 00 00       	call   4a6 <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 57 02 00 00       	call   2cb <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	8d 50 01             	lea    0x1(%eax),%edx
  ad:	89 55 08             	mov    %edx,0x8(%ebp)
  b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	pushl  0xc(%ebp)
 13a:	ff 75 08             	pushl  0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 47 01 00 00       	call   2e3 <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d7:	7c b3                	jl     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
      break;
 1db:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	pushl  0x8(%ebp)
 1fa:	e8 0c 01 00 00       	call   30b <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	e8 03 01 00 00       	call   323 <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	pushl  -0xc(%ebp)
 22c:	e8 c2 00 00 00       	call   2f3 <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x34>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x48>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0xf>
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 17                	jmp    2b1 <memmove+0x2b>
    *dst++ = *src++;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29d:	8d 50 01             	lea    0x1(%eax),%edx
 2a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a6:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2ac:	0f b6 12             	movzbl (%edx),%edx
 2af:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2b1:	8b 45 10             	mov    0x10(%ebp),%eax
 2b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b7:	89 55 10             	mov    %edx,0x10(%ebp)
 2ba:	85 c0                	test   %eax,%eax
 2bc:	7f dc                	jg     29a <memmove+0x14>
  return vdst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c3:	b8 01 00 00 00       	mov    $0x1,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <exit>:
SYSCALL(exit)
 2cb:	b8 02 00 00 00       	mov    $0x2,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <wait>:
SYSCALL(wait)
 2d3:	b8 03 00 00 00       	mov    $0x3,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <pipe>:
SYSCALL(pipe)
 2db:	b8 04 00 00 00       	mov    $0x4,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <read>:
SYSCALL(read)
 2e3:	b8 05 00 00 00       	mov    $0x5,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <write>:
SYSCALL(write)
 2eb:	b8 10 00 00 00       	mov    $0x10,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <close>:
SYSCALL(close)
 2f3:	b8 15 00 00 00       	mov    $0x15,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <kill>:
SYSCALL(kill)
 2fb:	b8 06 00 00 00       	mov    $0x6,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <exec>:
SYSCALL(exec)
 303:	b8 07 00 00 00       	mov    $0x7,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <open>:
SYSCALL(open)
 30b:	b8 0f 00 00 00       	mov    $0xf,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <mknod>:
SYSCALL(mknod)
 313:	b8 11 00 00 00       	mov    $0x11,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <unlink>:
SYSCALL(unlink)
 31b:	b8 12 00 00 00       	mov    $0x12,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <fstat>:
SYSCALL(fstat)
 323:	b8 08 00 00 00       	mov    $0x8,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <link>:
SYSCALL(link)
 32b:	b8 13 00 00 00       	mov    $0x13,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <mkdir>:
SYSCALL(mkdir)
 333:	b8 14 00 00 00       	mov    $0x14,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <chdir>:
SYSCALL(chdir)
 33b:	b8 09 00 00 00       	mov    $0x9,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <dup>:
SYSCALL(dup)
 343:	b8 0a 00 00 00       	mov    $0xa,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <getpid>:
SYSCALL(getpid)
 34b:	b8 0b 00 00 00       	mov    $0xb,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <sbrk>:
SYSCALL(sbrk)
 353:	b8 0c 00 00 00       	mov    $0xc,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sleep>:
SYSCALL(sleep)
 35b:	b8 0d 00 00 00       	mov    $0xd,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <uptime>:
SYSCALL(uptime)
 363:	b8 0e 00 00 00       	mov    $0xe,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <gettime>:
SYSCALL(gettime)
 36b:	b8 16 00 00 00       	mov    $0x16,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <settickets>:
SYSCALL(settickets)
 373:	b8 17 00 00 00       	mov    $0x17,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37b:	55                   	push   %ebp
 37c:	89 e5                	mov    %esp,%ebp
 37e:	83 ec 18             	sub    $0x18,%esp
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 387:	83 ec 04             	sub    $0x4,%esp
 38a:	6a 01                	push   $0x1
 38c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38f:	50                   	push   %eax
 390:	ff 75 08             	pushl  0x8(%ebp)
 393:	e8 53 ff ff ff       	call   2eb <write>
 398:	83 c4 10             	add    $0x10,%esp
}
 39b:	90                   	nop
 39c:	c9                   	leave  
 39d:	c3                   	ret    

0000039e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp
 3a1:	53                   	push   %ebx
 3a2:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ac:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b0:	74 17                	je     3c9 <printint+0x2b>
 3b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b6:	79 11                	jns    3c9 <printint+0x2b>
    neg = 1;
 3b8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c2:	f7 d8                	neg    %eax
 3c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c7:	eb 06                	jmp    3cf <printint+0x31>
  } else {
    x = xx;
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3d9:	8d 41 01             	lea    0x1(%ecx),%eax
 3dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3df:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e5:	ba 00 00 00 00       	mov    $0x0,%edx
 3ea:	f7 f3                	div    %ebx
 3ec:	89 d0                	mov    %edx,%eax
 3ee:	0f b6 80 28 0b 00 00 	movzbl 0xb28(%eax),%eax
 3f5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ff:	ba 00 00 00 00       	mov    $0x0,%edx
 404:	f7 f3                	div    %ebx
 406:	89 45 ec             	mov    %eax,-0x14(%ebp)
 409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40d:	75 c7                	jne    3d6 <printint+0x38>
  if(neg)
 40f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 413:	74 2d                	je     442 <printint+0xa4>
    buf[i++] = '-';
 415:	8b 45 f4             	mov    -0xc(%ebp),%eax
 418:	8d 50 01             	lea    0x1(%eax),%edx
 41b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 41e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 423:	eb 1d                	jmp    442 <printint+0xa4>
    putc(fd, buf[i]);
 425:	8d 55 dc             	lea    -0x24(%ebp),%edx
 428:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42b:	01 d0                	add    %edx,%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	0f be c0             	movsbl %al,%eax
 433:	83 ec 08             	sub    $0x8,%esp
 436:	50                   	push   %eax
 437:	ff 75 08             	pushl  0x8(%ebp)
 43a:	e8 3c ff ff ff       	call   37b <putc>
 43f:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 442:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 446:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44a:	79 d9                	jns    425 <printint+0x87>
}
 44c:	90                   	nop
 44d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 450:	c9                   	leave  
 451:	c3                   	ret    

00000452 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 452:	55                   	push   %ebp
 453:	89 e5                	mov    %esp,%ebp
 455:	83 ec 28             	sub    $0x28,%esp
 458:	8b 45 0c             	mov    0xc(%ebp),%eax
 45b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 45e:	8b 45 10             	mov    0x10(%ebp),%eax
 461:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 464:	8b 45 e0             	mov    -0x20(%ebp),%eax
 467:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 46a:	89 d0                	mov    %edx,%eax
 46c:	31 d2                	xor    %edx,%edx
 46e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 471:	8b 45 e0             	mov    -0x20(%ebp),%eax
 474:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 477:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 47b:	74 13                	je     490 <printlong+0x3e>
 47d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 480:	6a 00                	push   $0x0
 482:	6a 10                	push   $0x10
 484:	50                   	push   %eax
 485:	ff 75 08             	pushl  0x8(%ebp)
 488:	e8 11 ff ff ff       	call   39e <printint>
 48d:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 490:	8b 45 f0             	mov    -0x10(%ebp),%eax
 493:	6a 00                	push   $0x0
 495:	6a 10                	push   $0x10
 497:	50                   	push   %eax
 498:	ff 75 08             	pushl  0x8(%ebp)
 49b:	e8 fe fe ff ff       	call   39e <printint>
 4a0:	83 c4 10             	add    $0x10,%esp
}
 4a3:	90                   	nop
 4a4:	c9                   	leave  
 4a5:	c3                   	ret    

000004a6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 4a6:	55                   	push   %ebp
 4a7:	89 e5                	mov    %esp,%ebp
 4a9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b3:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b6:	83 c0 04             	add    $0x4,%eax
 4b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c3:	e9 88 01 00 00       	jmp    650 <printf+0x1aa>
    c = fmt[i] & 0xff;
 4c8:	8b 55 0c             	mov    0xc(%ebp),%edx
 4cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ce:	01 d0                	add    %edx,%eax
 4d0:	0f b6 00             	movzbl (%eax),%eax
 4d3:	0f be c0             	movsbl %al,%eax
 4d6:	25 ff 00 00 00       	and    $0xff,%eax
 4db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e2:	75 2c                	jne    510 <printf+0x6a>
      if(c == '%'){
 4e4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e8:	75 0c                	jne    4f6 <printf+0x50>
        state = '%';
 4ea:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4f1:	e9 56 01 00 00       	jmp    64c <printf+0x1a6>
      } else {
        putc(fd, c);
 4f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f9:	0f be c0             	movsbl %al,%eax
 4fc:	83 ec 08             	sub    $0x8,%esp
 4ff:	50                   	push   %eax
 500:	ff 75 08             	pushl  0x8(%ebp)
 503:	e8 73 fe ff ff       	call   37b <putc>
 508:	83 c4 10             	add    $0x10,%esp
 50b:	e9 3c 01 00 00       	jmp    64c <printf+0x1a6>
      }
    } else if(state == '%'){
 510:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 514:	0f 85 32 01 00 00    	jne    64c <printf+0x1a6>
      if(c == 'd'){
 51a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51e:	75 1e                	jne    53e <printf+0x98>
        printint(fd, *ap, 10, 1);
 520:	8b 45 e8             	mov    -0x18(%ebp),%eax
 523:	8b 00                	mov    (%eax),%eax
 525:	6a 01                	push   $0x1
 527:	6a 0a                	push   $0xa
 529:	50                   	push   %eax
 52a:	ff 75 08             	pushl  0x8(%ebp)
 52d:	e8 6c fe ff ff       	call   39e <printint>
 532:	83 c4 10             	add    $0x10,%esp
        ap++;
 535:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 539:	e9 07 01 00 00       	jmp    645 <printf+0x19f>
      } else if(c == 'l') {
 53e:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 542:	75 29                	jne    56d <printf+0xc7>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 544:	8b 45 e8             	mov    -0x18(%ebp),%eax
 547:	8b 50 04             	mov    0x4(%eax),%edx
 54a:	8b 00                	mov    (%eax),%eax
 54c:	83 ec 0c             	sub    $0xc,%esp
 54f:	6a 00                	push   $0x0
 551:	6a 0a                	push   $0xa
 553:	52                   	push   %edx
 554:	50                   	push   %eax
 555:	ff 75 08             	pushl  0x8(%ebp)
 558:	e8 f5 fe ff ff       	call   452 <printlong>
 55d:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 564:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 568:	e9 d8 00 00 00       	jmp    645 <printf+0x19f>
      } else if(c == 'x' || c == 'p'){
 56d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 571:	74 06                	je     579 <printf+0xd3>
 573:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 577:	75 1e                	jne    597 <printf+0xf1>
        printint(fd, *ap, 16, 0);
 579:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57c:	8b 00                	mov    (%eax),%eax
 57e:	6a 00                	push   $0x0
 580:	6a 10                	push   $0x10
 582:	50                   	push   %eax
 583:	ff 75 08             	pushl  0x8(%ebp)
 586:	e8 13 fe ff ff       	call   39e <printint>
 58b:	83 c4 10             	add    $0x10,%esp
        ap++;
 58e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 592:	e9 ae 00 00 00       	jmp    645 <printf+0x19f>
      } else if(c == 's'){
 597:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 59b:	75 43                	jne    5e0 <printf+0x13a>
        s = (char*)*ap;
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ad:	75 25                	jne    5d4 <printf+0x12e>
          s = "(null)";
 5af:	c7 45 f4 b2 08 00 00 	movl   $0x8b2,-0xc(%ebp)
        while(*s != 0){
 5b6:	eb 1c                	jmp    5d4 <printf+0x12e>
          putc(fd, *s);
 5b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bb:	0f b6 00             	movzbl (%eax),%eax
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	83 ec 08             	sub    $0x8,%esp
 5c4:	50                   	push   %eax
 5c5:	ff 75 08             	pushl  0x8(%ebp)
 5c8:	e8 ae fd ff ff       	call   37b <putc>
 5cd:	83 c4 10             	add    $0x10,%esp
          s++;
 5d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d7:	0f b6 00             	movzbl (%eax),%eax
 5da:	84 c0                	test   %al,%al
 5dc:	75 da                	jne    5b8 <printf+0x112>
 5de:	eb 65                	jmp    645 <printf+0x19f>
        }
      } else if(c == 'c'){
 5e0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e4:	75 1d                	jne    603 <printf+0x15d>
        putc(fd, *ap);
 5e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e9:	8b 00                	mov    (%eax),%eax
 5eb:	0f be c0             	movsbl %al,%eax
 5ee:	83 ec 08             	sub    $0x8,%esp
 5f1:	50                   	push   %eax
 5f2:	ff 75 08             	pushl  0x8(%ebp)
 5f5:	e8 81 fd ff ff       	call   37b <putc>
 5fa:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 601:	eb 42                	jmp    645 <printf+0x19f>
      } else if(c == '%'){
 603:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 607:	75 17                	jne    620 <printf+0x17a>
        putc(fd, c);
 609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60c:	0f be c0             	movsbl %al,%eax
 60f:	83 ec 08             	sub    $0x8,%esp
 612:	50                   	push   %eax
 613:	ff 75 08             	pushl  0x8(%ebp)
 616:	e8 60 fd ff ff       	call   37b <putc>
 61b:	83 c4 10             	add    $0x10,%esp
 61e:	eb 25                	jmp    645 <printf+0x19f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 620:	83 ec 08             	sub    $0x8,%esp
 623:	6a 25                	push   $0x25
 625:	ff 75 08             	pushl  0x8(%ebp)
 628:	e8 4e fd ff ff       	call   37b <putc>
 62d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 633:	0f be c0             	movsbl %al,%eax
 636:	83 ec 08             	sub    $0x8,%esp
 639:	50                   	push   %eax
 63a:	ff 75 08             	pushl  0x8(%ebp)
 63d:	e8 39 fd ff ff       	call   37b <putc>
 642:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 645:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 64c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 650:	8b 55 0c             	mov    0xc(%ebp),%edx
 653:	8b 45 f0             	mov    -0x10(%ebp),%eax
 656:	01 d0                	add    %edx,%eax
 658:	0f b6 00             	movzbl (%eax),%eax
 65b:	84 c0                	test   %al,%al
 65d:	0f 85 65 fe ff ff    	jne    4c8 <printf+0x22>
    }
  }
}
 663:	90                   	nop
 664:	c9                   	leave  
 665:	c3                   	ret    

00000666 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 666:	55                   	push   %ebp
 667:	89 e5                	mov    %esp,%ebp
 669:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	83 e8 08             	sub    $0x8,%eax
 672:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 675:	a1 44 0b 00 00       	mov    0xb44,%eax
 67a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67d:	eb 24                	jmp    6a3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 687:	77 12                	ja     69b <free+0x35>
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68f:	77 24                	ja     6b5 <free+0x4f>
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 699:	77 1a                	ja     6b5 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 00                	mov    (%eax),%eax
 6a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a9:	76 d4                	jbe    67f <free+0x19>
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b3:	76 ca                	jbe    67f <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	8b 40 04             	mov    0x4(%eax),%eax
 6bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	01 c2                	add    %eax,%edx
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	39 c2                	cmp    %eax,%edx
 6ce:	75 24                	jne    6f4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	8b 50 04             	mov    0x4(%eax),%edx
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	8b 40 04             	mov    0x4(%eax),%eax
 6de:	01 c2                	add    %eax,%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	8b 10                	mov    (%eax),%edx
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	89 10                	mov    %edx,(%eax)
 6f2:	eb 0a                	jmp    6fe <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 10                	mov    (%eax),%edx
 6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	8b 40 04             	mov    0x4(%eax),%eax
 704:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	01 d0                	add    %edx,%eax
 710:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 713:	75 20                	jne    735 <free+0xcf>
    p->s.size += bp->s.size;
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 50 04             	mov    0x4(%eax),%edx
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	01 c2                	add    %eax,%edx
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	8b 10                	mov    (%eax),%edx
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	89 10                	mov    %edx,(%eax)
 733:	eb 08                	jmp    73d <free+0xd7>
  } else
    p->s.ptr = bp;
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73b:	89 10                	mov    %edx,(%eax)
  freep = p;
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	a3 44 0b 00 00       	mov    %eax,0xb44
}
 745:	90                   	nop
 746:	c9                   	leave  
 747:	c3                   	ret    

00000748 <morecore>:

static Header*
morecore(uint nu)
{
 748:	55                   	push   %ebp
 749:	89 e5                	mov    %esp,%ebp
 74b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 755:	77 07                	ja     75e <morecore+0x16>
    nu = 4096;
 757:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	c1 e0 03             	shl    $0x3,%eax
 764:	83 ec 0c             	sub    $0xc,%esp
 767:	50                   	push   %eax
 768:	e8 e6 fb ff ff       	call   353 <sbrk>
 76d:	83 c4 10             	add    $0x10,%esp
 770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 773:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 777:	75 07                	jne    780 <morecore+0x38>
    return 0;
 779:	b8 00 00 00 00       	mov    $0x0,%eax
 77e:	eb 26                	jmp    7a6 <morecore+0x5e>
  hp = (Header*)p;
 780:	8b 45 f4             	mov    -0xc(%ebp),%eax
 783:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 786:	8b 45 f0             	mov    -0x10(%ebp),%eax
 789:	8b 55 08             	mov    0x8(%ebp),%edx
 78c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	83 c0 08             	add    $0x8,%eax
 795:	83 ec 0c             	sub    $0xc,%esp
 798:	50                   	push   %eax
 799:	e8 c8 fe ff ff       	call   666 <free>
 79e:	83 c4 10             	add    $0x10,%esp
  return freep;
 7a1:	a1 44 0b 00 00       	mov    0xb44,%eax
}
 7a6:	c9                   	leave  
 7a7:	c3                   	ret    

000007a8 <malloc>:

void*
malloc(uint nbytes)
{
 7a8:	55                   	push   %ebp
 7a9:	89 e5                	mov    %esp,%ebp
 7ab:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ae:	8b 45 08             	mov    0x8(%ebp),%eax
 7b1:	83 c0 07             	add    $0x7,%eax
 7b4:	c1 e8 03             	shr    $0x3,%eax
 7b7:	83 c0 01             	add    $0x1,%eax
 7ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7bd:	a1 44 0b 00 00       	mov    0xb44,%eax
 7c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c9:	75 23                	jne    7ee <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7cb:	c7 45 f0 3c 0b 00 00 	movl   $0xb3c,-0x10(%ebp)
 7d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d5:	a3 44 0b 00 00       	mov    %eax,0xb44
 7da:	a1 44 0b 00 00       	mov    0xb44,%eax
 7df:	a3 3c 0b 00 00       	mov    %eax,0xb3c
    base.s.size = 0;
 7e4:	c7 05 40 0b 00 00 00 	movl   $0x0,0xb40
 7eb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8b 40 04             	mov    0x4(%eax),%eax
 7fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ff:	72 4d                	jb     84e <malloc+0xa6>
      if(p->s.size == nunits)
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 40 04             	mov    0x4(%eax),%eax
 807:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80a:	75 0c                	jne    818 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 10                	mov    (%eax),%edx
 811:	8b 45 f0             	mov    -0x10(%ebp),%eax
 814:	89 10                	mov    %edx,(%eax)
 816:	eb 26                	jmp    83e <malloc+0x96>
      else {
        p->s.size -= nunits;
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 821:	89 c2                	mov    %eax,%edx
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 40 04             	mov    0x4(%eax),%eax
 82f:	c1 e0 03             	shl    $0x3,%eax
 832:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 841:	a3 44 0b 00 00       	mov    %eax,0xb44
      return (void*)(p + 1);
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	83 c0 08             	add    $0x8,%eax
 84c:	eb 3b                	jmp    889 <malloc+0xe1>
    }
    if(p == freep)
 84e:	a1 44 0b 00 00       	mov    0xb44,%eax
 853:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 856:	75 1e                	jne    876 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 858:	83 ec 0c             	sub    $0xc,%esp
 85b:	ff 75 ec             	pushl  -0x14(%ebp)
 85e:	e8 e5 fe ff ff       	call   748 <morecore>
 863:	83 c4 10             	add    $0x10,%esp
 866:	89 45 f4             	mov    %eax,-0xc(%ebp)
 869:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86d:	75 07                	jne    876 <malloc+0xce>
        return 0;
 86f:	b8 00 00 00 00       	mov    $0x0,%eax
 874:	eb 13                	jmp    889 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	8b 00                	mov    (%eax),%eax
 881:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 884:	e9 6d ff ff ff       	jmp    7f6 <malloc+0x4e>
  }
}
 889:	c9                   	leave  
 88a:	c3                   	ret    
