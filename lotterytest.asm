
_lotterytest:     file format elf32-i386


Disassembly of section .text:

00000000 <spin>:
#include "types.h"
#include "user.h"
#include "date.h"

// Do some useless computations
void spin(int tix) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
    struct rtcdate end;
    unsigned x = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    unsigned y = 0;
   d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while (x < 100000) {
  14:	eb 1a                	jmp    30 <spin+0x30>
        y = 0;
  16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        while (y < 10000) {
  1d:	eb 04                	jmp    23 <spin+0x23>
            y++;
  1f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
        while (y < 10000) {
  23:	81 7d f0 0f 27 00 00 	cmpl   $0x270f,-0x10(%ebp)
  2a:	76 f3                	jbe    1f <spin+0x1f>
        }
        x++;
  2c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (x < 100000) {
  30:	81 7d f4 9f 86 01 00 	cmpl   $0x1869f,-0xc(%ebp)
  37:	76 dd                	jbe    16 <spin+0x16>
    }

    gettime(&end);
  39:	83 ec 0c             	sub    $0xc,%esp
  3c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  3f:	50                   	push   %eax
  40:	e8 f2 03 00 00       	call   437 <gettime>
  45:	83 c4 10             	add    $0x10,%esp
    printf(0, "spin with %d tickets ended at %d hours %d minutes %d seconds\n", tix, end.hour, end.minute, end.second);
  48:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  51:	83 ec 08             	sub    $0x8,%esp
  54:	51                   	push   %ecx
  55:	52                   	push   %edx
  56:	50                   	push   %eax
  57:	ff 75 08             	pushl  0x8(%ebp)
  5a:	68 58 09 00 00       	push   $0x958
  5f:	6a 00                	push   $0x0
  61:	e8 0c 05 00 00       	call   572 <printf>
  66:	83 c4 20             	add    $0x20,%esp
}
  69:	90                   	nop
  6a:	c9                   	leave  
  6b:	c3                   	ret    

0000006c <main>:

int main() {
  6c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  70:	83 e4 f0             	and    $0xfffffff0,%esp
  73:	ff 71 fc             	pushl  -0x4(%ecx)
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	51                   	push   %ecx
  7a:	83 ec 34             	sub    $0x34,%esp
    int pid1;
    int pid2;
    int pid3;
    struct rtcdate start;
    gettime(&start);
  7d:	83 ec 0c             	sub    $0xc,%esp
  80:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  83:	50                   	push   %eax
  84:	e8 ae 03 00 00       	call   437 <gettime>
  89:	83 c4 10             	add    $0x10,%esp
    printf(0, "starting test at %d hours %d minutes %d seconds\n", start.hour, start.minute, start.second);
  8c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  95:	83 ec 0c             	sub    $0xc,%esp
  98:	51                   	push   %ecx
  99:	52                   	push   %edx
  9a:	50                   	push   %eax
  9b:	68 98 09 00 00       	push   $0x998
  a0:	6a 00                	push   $0x0
  a2:	e8 cb 04 00 00       	call   572 <printf>
  a7:	83 c4 20             	add    $0x20,%esp
    if ((pid1 = fork()) == 0) {
  aa:	e8 e0 02 00 00       	call   38f <fork>
  af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  b6:	75 1f                	jne    d7 <main+0x6b>
        settickets(75);
  b8:	83 ec 0c             	sub    $0xc,%esp
  bb:	6a 4b                	push   $0x4b
  bd:	e8 7d 03 00 00       	call   43f <settickets>
  c2:	83 c4 10             	add    $0x10,%esp
        spin(75);
  c5:	83 ec 0c             	sub    $0xc,%esp
  c8:	6a 4b                	push   $0x4b
  ca:	e8 31 ff ff ff       	call   0 <spin>
  cf:	83 c4 10             	add    $0x10,%esp
        exit();
  d2:	e8 c0 02 00 00       	call   397 <exit>
    }
    else if ((pid2 = fork()) == 0) {
  d7:	e8 b3 02 00 00       	call   38f <fork>
  dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  e3:	75 1f                	jne    104 <main+0x98>
        settickets(20);
  e5:	83 ec 0c             	sub    $0xc,%esp
  e8:	6a 14                	push   $0x14
  ea:	e8 50 03 00 00       	call   43f <settickets>
  ef:	83 c4 10             	add    $0x10,%esp
        spin(20);
  f2:	83 ec 0c             	sub    $0xc,%esp
  f5:	6a 14                	push   $0x14
  f7:	e8 04 ff ff ff       	call   0 <spin>
  fc:	83 c4 10             	add    $0x10,%esp
        exit();
  ff:	e8 93 02 00 00       	call   397 <exit>
    } 
    else if ((pid3 = fork()) == 0) {
 104:	e8 86 02 00 00       	call   38f <fork>
 109:	89 45 ec             	mov    %eax,-0x14(%ebp)
 10c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 110:	75 1f                	jne    131 <main+0xc5>
        settickets(5);
 112:	83 ec 0c             	sub    $0xc,%esp
 115:	6a 05                	push   $0x5
 117:	e8 23 03 00 00       	call   43f <settickets>
 11c:	83 c4 10             	add    $0x10,%esp
        spin(5);
 11f:	83 ec 0c             	sub    $0xc,%esp
 122:	6a 05                	push   $0x5
 124:	e8 d7 fe ff ff       	call   0 <spin>
 129:	83 c4 10             	add    $0x10,%esp
        exit();
 12c:	e8 66 02 00 00       	call   397 <exit>
    }
    // Go to sleep and wait for subprocesses to finish
    wait();
 131:	e8 69 02 00 00       	call   39f <wait>
    wait();
 136:	e8 64 02 00 00       	call   39f <wait>
    exit();
 13b:	e8 57 02 00 00       	call   397 <exit>

00000140 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 145:	8b 4d 08             	mov    0x8(%ebp),%ecx
 148:	8b 55 10             	mov    0x10(%ebp),%edx
 14b:	8b 45 0c             	mov    0xc(%ebp),%eax
 14e:	89 cb                	mov    %ecx,%ebx
 150:	89 df                	mov    %ebx,%edi
 152:	89 d1                	mov    %edx,%ecx
 154:	fc                   	cld    
 155:	f3 aa                	rep stos %al,%es:(%edi)
 157:	89 ca                	mov    %ecx,%edx
 159:	89 fb                	mov    %edi,%ebx
 15b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 15e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 161:	90                   	nop
 162:	5b                   	pop    %ebx
 163:	5f                   	pop    %edi
 164:	5d                   	pop    %ebp
 165:	c3                   	ret    

00000166 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 172:	90                   	nop
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	8d 50 01             	lea    0x1(%eax),%edx
 179:	89 55 08             	mov    %edx,0x8(%ebp)
 17c:	8b 55 0c             	mov    0xc(%ebp),%edx
 17f:	8d 4a 01             	lea    0x1(%edx),%ecx
 182:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 185:	0f b6 12             	movzbl (%edx),%edx
 188:	88 10                	mov    %dl,(%eax)
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	84 c0                	test   %al,%al
 18f:	75 e2                	jne    173 <strcpy+0xd>
    ;
  return os;
 191:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 194:	c9                   	leave  
 195:	c3                   	ret    

00000196 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 199:	eb 08                	jmp    1a3 <strcmp+0xd>
    p++, q++;
 19b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	0f b6 00             	movzbl (%eax),%eax
 1a9:	84 c0                	test   %al,%al
 1ab:	74 10                	je     1bd <strcmp+0x27>
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	0f b6 10             	movzbl (%eax),%edx
 1b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b6:	0f b6 00             	movzbl (%eax),%eax
 1b9:	38 c2                	cmp    %al,%dl
 1bb:	74 de                	je     19b <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	0f b6 00             	movzbl (%eax),%eax
 1c3:	0f b6 d0             	movzbl %al,%edx
 1c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c9:	0f b6 00             	movzbl (%eax),%eax
 1cc:	0f b6 c0             	movzbl %al,%eax
 1cf:	29 c2                	sub    %eax,%edx
 1d1:	89 d0                	mov    %edx,%eax
}
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    

000001d5 <strlen>:

uint
strlen(char *s)
{
 1d5:	55                   	push   %ebp
 1d6:	89 e5                	mov    %esp,%ebp
 1d8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e2:	eb 04                	jmp    1e8 <strlen+0x13>
 1e4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	01 d0                	add    %edx,%eax
 1f0:	0f b6 00             	movzbl (%eax),%eax
 1f3:	84 c0                	test   %al,%al
 1f5:	75 ed                	jne    1e4 <strlen+0xf>
    ;
  return n;
 1f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1fa:	c9                   	leave  
 1fb:	c3                   	ret    

000001fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ff:	8b 45 10             	mov    0x10(%ebp),%eax
 202:	50                   	push   %eax
 203:	ff 75 0c             	pushl  0xc(%ebp)
 206:	ff 75 08             	pushl  0x8(%ebp)
 209:	e8 32 ff ff ff       	call   140 <stosb>
 20e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 211:	8b 45 08             	mov    0x8(%ebp),%eax
}
 214:	c9                   	leave  
 215:	c3                   	ret    

00000216 <strchr>:

char*
strchr(const char *s, char c)
{
 216:	55                   	push   %ebp
 217:	89 e5                	mov    %esp,%ebp
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	8b 45 0c             	mov    0xc(%ebp),%eax
 21f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 222:	eb 14                	jmp    238 <strchr+0x22>
    if(*s == c)
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 22d:	75 05                	jne    234 <strchr+0x1e>
      return (char*)s;
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	eb 13                	jmp    247 <strchr+0x31>
  for(; *s; s++)
 234:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	84 c0                	test   %al,%al
 240:	75 e2                	jne    224 <strchr+0xe>
  return 0;
 242:	b8 00 00 00 00       	mov    $0x0,%eax
}
 247:	c9                   	leave  
 248:	c3                   	ret    

00000249 <gets>:

char*
gets(char *buf, int max)
{
 249:	55                   	push   %ebp
 24a:	89 e5                	mov    %esp,%ebp
 24c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 256:	eb 42                	jmp    29a <gets+0x51>
    cc = read(0, &c, 1);
 258:	83 ec 04             	sub    $0x4,%esp
 25b:	6a 01                	push   $0x1
 25d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 260:	50                   	push   %eax
 261:	6a 00                	push   $0x0
 263:	e8 47 01 00 00       	call   3af <read>
 268:	83 c4 10             	add    $0x10,%esp
 26b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 26e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 272:	7e 33                	jle    2a7 <gets+0x5e>
      break;
    buf[i++] = c;
 274:	8b 45 f4             	mov    -0xc(%ebp),%eax
 277:	8d 50 01             	lea    0x1(%eax),%edx
 27a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 27d:	89 c2                	mov    %eax,%edx
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	01 c2                	add    %eax,%edx
 284:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 288:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 28a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 28e:	3c 0a                	cmp    $0xa,%al
 290:	74 16                	je     2a8 <gets+0x5f>
 292:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 296:	3c 0d                	cmp    $0xd,%al
 298:	74 0e                	je     2a8 <gets+0x5f>
  for(i=0; i+1 < max; ){
 29a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 29d:	83 c0 01             	add    $0x1,%eax
 2a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2a3:	7c b3                	jl     258 <gets+0xf>
 2a5:	eb 01                	jmp    2a8 <gets+0x5f>
      break;
 2a7:	90                   	nop
      break;
  }
  buf[i] = '\0';
 2a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	01 d0                	add    %edx,%eax
 2b0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b6:	c9                   	leave  
 2b7:	c3                   	ret    

000002b8 <stat>:

int
stat(char *n, struct stat *st)
{
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
 2bb:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2be:	83 ec 08             	sub    $0x8,%esp
 2c1:	6a 00                	push   $0x0
 2c3:	ff 75 08             	pushl  0x8(%ebp)
 2c6:	e8 0c 01 00 00       	call   3d7 <open>
 2cb:	83 c4 10             	add    $0x10,%esp
 2ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2d5:	79 07                	jns    2de <stat+0x26>
    return -1;
 2d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2dc:	eb 25                	jmp    303 <stat+0x4b>
  r = fstat(fd, st);
 2de:	83 ec 08             	sub    $0x8,%esp
 2e1:	ff 75 0c             	pushl  0xc(%ebp)
 2e4:	ff 75 f4             	pushl  -0xc(%ebp)
 2e7:	e8 03 01 00 00       	call   3ef <fstat>
 2ec:	83 c4 10             	add    $0x10,%esp
 2ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2f2:	83 ec 0c             	sub    $0xc,%esp
 2f5:	ff 75 f4             	pushl  -0xc(%ebp)
 2f8:	e8 c2 00 00 00       	call   3bf <close>
 2fd:	83 c4 10             	add    $0x10,%esp
  return r;
 300:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 303:	c9                   	leave  
 304:	c3                   	ret    

00000305 <atoi>:

int
atoi(const char *s)
{
 305:	55                   	push   %ebp
 306:	89 e5                	mov    %esp,%ebp
 308:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 30b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 312:	eb 25                	jmp    339 <atoi+0x34>
    n = n*10 + *s++ - '0';
 314:	8b 55 fc             	mov    -0x4(%ebp),%edx
 317:	89 d0                	mov    %edx,%eax
 319:	c1 e0 02             	shl    $0x2,%eax
 31c:	01 d0                	add    %edx,%eax
 31e:	01 c0                	add    %eax,%eax
 320:	89 c1                	mov    %eax,%ecx
 322:	8b 45 08             	mov    0x8(%ebp),%eax
 325:	8d 50 01             	lea    0x1(%eax),%edx
 328:	89 55 08             	mov    %edx,0x8(%ebp)
 32b:	0f b6 00             	movzbl (%eax),%eax
 32e:	0f be c0             	movsbl %al,%eax
 331:	01 c8                	add    %ecx,%eax
 333:	83 e8 30             	sub    $0x30,%eax
 336:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 339:	8b 45 08             	mov    0x8(%ebp),%eax
 33c:	0f b6 00             	movzbl (%eax),%eax
 33f:	3c 2f                	cmp    $0x2f,%al
 341:	7e 0a                	jle    34d <atoi+0x48>
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	0f b6 00             	movzbl (%eax),%eax
 349:	3c 39                	cmp    $0x39,%al
 34b:	7e c7                	jle    314 <atoi+0xf>
  return n;
 34d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 350:	c9                   	leave  
 351:	c3                   	ret    

00000352 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 35e:	8b 45 0c             	mov    0xc(%ebp),%eax
 361:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 364:	eb 17                	jmp    37d <memmove+0x2b>
    *dst++ = *src++;
 366:	8b 45 fc             	mov    -0x4(%ebp),%eax
 369:	8d 50 01             	lea    0x1(%eax),%edx
 36c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 36f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 372:	8d 4a 01             	lea    0x1(%edx),%ecx
 375:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 378:	0f b6 12             	movzbl (%edx),%edx
 37b:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 37d:	8b 45 10             	mov    0x10(%ebp),%eax
 380:	8d 50 ff             	lea    -0x1(%eax),%edx
 383:	89 55 10             	mov    %edx,0x10(%ebp)
 386:	85 c0                	test   %eax,%eax
 388:	7f dc                	jg     366 <memmove+0x14>
  return vdst;
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 38d:	c9                   	leave  
 38e:	c3                   	ret    

0000038f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38f:	b8 01 00 00 00       	mov    $0x1,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <exit>:
SYSCALL(exit)
 397:	b8 02 00 00 00       	mov    $0x2,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <wait>:
SYSCALL(wait)
 39f:	b8 03 00 00 00       	mov    $0x3,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <pipe>:
SYSCALL(pipe)
 3a7:	b8 04 00 00 00       	mov    $0x4,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <read>:
SYSCALL(read)
 3af:	b8 05 00 00 00       	mov    $0x5,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <write>:
SYSCALL(write)
 3b7:	b8 10 00 00 00       	mov    $0x10,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <close>:
SYSCALL(close)
 3bf:	b8 15 00 00 00       	mov    $0x15,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <kill>:
SYSCALL(kill)
 3c7:	b8 06 00 00 00       	mov    $0x6,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <exec>:
SYSCALL(exec)
 3cf:	b8 07 00 00 00       	mov    $0x7,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <open>:
SYSCALL(open)
 3d7:	b8 0f 00 00 00       	mov    $0xf,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <mknod>:
SYSCALL(mknod)
 3df:	b8 11 00 00 00       	mov    $0x11,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <unlink>:
SYSCALL(unlink)
 3e7:	b8 12 00 00 00       	mov    $0x12,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <fstat>:
SYSCALL(fstat)
 3ef:	b8 08 00 00 00       	mov    $0x8,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <link>:
SYSCALL(link)
 3f7:	b8 13 00 00 00       	mov    $0x13,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <mkdir>:
SYSCALL(mkdir)
 3ff:	b8 14 00 00 00       	mov    $0x14,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <chdir>:
SYSCALL(chdir)
 407:	b8 09 00 00 00       	mov    $0x9,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <dup>:
SYSCALL(dup)
 40f:	b8 0a 00 00 00       	mov    $0xa,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <getpid>:
SYSCALL(getpid)
 417:	b8 0b 00 00 00       	mov    $0xb,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <sbrk>:
SYSCALL(sbrk)
 41f:	b8 0c 00 00 00       	mov    $0xc,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <sleep>:
SYSCALL(sleep)
 427:	b8 0d 00 00 00       	mov    $0xd,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <uptime>:
SYSCALL(uptime)
 42f:	b8 0e 00 00 00       	mov    $0xe,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <gettime>:
SYSCALL(gettime)
 437:	b8 16 00 00 00       	mov    $0x16,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <settickets>:
SYSCALL(settickets)
 43f:	b8 17 00 00 00       	mov    $0x17,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 447:	55                   	push   %ebp
 448:	89 e5                	mov    %esp,%ebp
 44a:	83 ec 18             	sub    $0x18,%esp
 44d:	8b 45 0c             	mov    0xc(%ebp),%eax
 450:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 453:	83 ec 04             	sub    $0x4,%esp
 456:	6a 01                	push   $0x1
 458:	8d 45 f4             	lea    -0xc(%ebp),%eax
 45b:	50                   	push   %eax
 45c:	ff 75 08             	pushl  0x8(%ebp)
 45f:	e8 53 ff ff ff       	call   3b7 <write>
 464:	83 c4 10             	add    $0x10,%esp
}
 467:	90                   	nop
 468:	c9                   	leave  
 469:	c3                   	ret    

0000046a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46a:	55                   	push   %ebp
 46b:	89 e5                	mov    %esp,%ebp
 46d:	53                   	push   %ebx
 46e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 471:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 478:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 47c:	74 17                	je     495 <printint+0x2b>
 47e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 482:	79 11                	jns    495 <printint+0x2b>
    neg = 1;
 484:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 48b:	8b 45 0c             	mov    0xc(%ebp),%eax
 48e:	f7 d8                	neg    %eax
 490:	89 45 ec             	mov    %eax,-0x14(%ebp)
 493:	eb 06                	jmp    49b <printint+0x31>
  } else {
    x = xx;
 495:	8b 45 0c             	mov    0xc(%ebp),%eax
 498:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 49b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a5:	8d 41 01             	lea    0x1(%ecx),%eax
 4a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b1:	ba 00 00 00 00       	mov    $0x0,%edx
 4b6:	f7 f3                	div    %ebx
 4b8:	89 d0                	mov    %edx,%eax
 4ba:	0f b6 80 58 0c 00 00 	movzbl 0xc58(%eax),%eax
 4c1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4cb:	ba 00 00 00 00       	mov    $0x0,%edx
 4d0:	f7 f3                	div    %ebx
 4d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d9:	75 c7                	jne    4a2 <printint+0x38>
  if(neg)
 4db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4df:	74 2d                	je     50e <printint+0xa4>
    buf[i++] = '-';
 4e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e4:	8d 50 01             	lea    0x1(%eax),%edx
 4e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ea:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ef:	eb 1d                	jmp    50e <printint+0xa4>
    putc(fd, buf[i]);
 4f1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f7:	01 d0                	add    %edx,%eax
 4f9:	0f b6 00             	movzbl (%eax),%eax
 4fc:	0f be c0             	movsbl %al,%eax
 4ff:	83 ec 08             	sub    $0x8,%esp
 502:	50                   	push   %eax
 503:	ff 75 08             	pushl  0x8(%ebp)
 506:	e8 3c ff ff ff       	call   447 <putc>
 50b:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 50e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 516:	79 d9                	jns    4f1 <printint+0x87>
}
 518:	90                   	nop
 519:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 51c:	c9                   	leave  
 51d:	c3                   	ret    

0000051e <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 51e:	55                   	push   %ebp
 51f:	89 e5                	mov    %esp,%ebp
 521:	83 ec 28             	sub    $0x28,%esp
 524:	8b 45 0c             	mov    0xc(%ebp),%eax
 527:	89 45 e0             	mov    %eax,-0x20(%ebp)
 52a:	8b 45 10             	mov    0x10(%ebp),%eax
 52d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 530:	8b 45 e0             	mov    -0x20(%ebp),%eax
 533:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 536:	89 d0                	mov    %edx,%eax
 538:	31 d2                	xor    %edx,%edx
 53a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 53d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 540:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 543:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 547:	74 13                	je     55c <printlong+0x3e>
 549:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54c:	6a 00                	push   $0x0
 54e:	6a 10                	push   $0x10
 550:	50                   	push   %eax
 551:	ff 75 08             	pushl  0x8(%ebp)
 554:	e8 11 ff ff ff       	call   46a <printint>
 559:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 55c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 55f:	6a 00                	push   $0x0
 561:	6a 10                	push   $0x10
 563:	50                   	push   %eax
 564:	ff 75 08             	pushl  0x8(%ebp)
 567:	e8 fe fe ff ff       	call   46a <printint>
 56c:	83 c4 10             	add    $0x10,%esp
}
 56f:	90                   	nop
 570:	c9                   	leave  
 571:	c3                   	ret    

00000572 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 572:	55                   	push   %ebp
 573:	89 e5                	mov    %esp,%ebp
 575:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 578:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 57f:	8d 45 0c             	lea    0xc(%ebp),%eax
 582:	83 c0 04             	add    $0x4,%eax
 585:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 588:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 58f:	e9 88 01 00 00       	jmp    71c <printf+0x1aa>
    c = fmt[i] & 0xff;
 594:	8b 55 0c             	mov    0xc(%ebp),%edx
 597:	8b 45 f0             	mov    -0x10(%ebp),%eax
 59a:	01 d0                	add    %edx,%eax
 59c:	0f b6 00             	movzbl (%eax),%eax
 59f:	0f be c0             	movsbl %al,%eax
 5a2:	25 ff 00 00 00       	and    $0xff,%eax
 5a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ae:	75 2c                	jne    5dc <printf+0x6a>
      if(c == '%'){
 5b0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b4:	75 0c                	jne    5c2 <printf+0x50>
        state = '%';
 5b6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5bd:	e9 56 01 00 00       	jmp    718 <printf+0x1a6>
      } else {
        putc(fd, c);
 5c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	83 ec 08             	sub    $0x8,%esp
 5cb:	50                   	push   %eax
 5cc:	ff 75 08             	pushl  0x8(%ebp)
 5cf:	e8 73 fe ff ff       	call   447 <putc>
 5d4:	83 c4 10             	add    $0x10,%esp
 5d7:	e9 3c 01 00 00       	jmp    718 <printf+0x1a6>
      }
    } else if(state == '%'){
 5dc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5e0:	0f 85 32 01 00 00    	jne    718 <printf+0x1a6>
      if(c == 'd'){
 5e6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ea:	75 1e                	jne    60a <printf+0x98>
        printint(fd, *ap, 10, 1);
 5ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ef:	8b 00                	mov    (%eax),%eax
 5f1:	6a 01                	push   $0x1
 5f3:	6a 0a                	push   $0xa
 5f5:	50                   	push   %eax
 5f6:	ff 75 08             	pushl  0x8(%ebp)
 5f9:	e8 6c fe ff ff       	call   46a <printint>
 5fe:	83 c4 10             	add    $0x10,%esp
        ap++;
 601:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 605:	e9 07 01 00 00       	jmp    711 <printf+0x19f>
      } else if(c == 'l') {
 60a:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 60e:	75 29                	jne    639 <printf+0xc7>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 610:	8b 45 e8             	mov    -0x18(%ebp),%eax
 613:	8b 50 04             	mov    0x4(%eax),%edx
 616:	8b 00                	mov    (%eax),%eax
 618:	83 ec 0c             	sub    $0xc,%esp
 61b:	6a 00                	push   $0x0
 61d:	6a 0a                	push   $0xa
 61f:	52                   	push   %edx
 620:	50                   	push   %eax
 621:	ff 75 08             	pushl  0x8(%ebp)
 624:	e8 f5 fe ff ff       	call   51e <printlong>
 629:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 62c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 630:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 634:	e9 d8 00 00 00       	jmp    711 <printf+0x19f>
      } else if(c == 'x' || c == 'p'){
 639:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 63d:	74 06                	je     645 <printf+0xd3>
 63f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 643:	75 1e                	jne    663 <printf+0xf1>
        printint(fd, *ap, 16, 0);
 645:	8b 45 e8             	mov    -0x18(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	6a 00                	push   $0x0
 64c:	6a 10                	push   $0x10
 64e:	50                   	push   %eax
 64f:	ff 75 08             	pushl  0x8(%ebp)
 652:	e8 13 fe ff ff       	call   46a <printint>
 657:	83 c4 10             	add    $0x10,%esp
        ap++;
 65a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65e:	e9 ae 00 00 00       	jmp    711 <printf+0x19f>
      } else if(c == 's'){
 663:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 667:	75 43                	jne    6ac <printf+0x13a>
        s = (char*)*ap;
 669:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 671:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 675:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 679:	75 25                	jne    6a0 <printf+0x12e>
          s = "(null)";
 67b:	c7 45 f4 c9 09 00 00 	movl   $0x9c9,-0xc(%ebp)
        while(*s != 0){
 682:	eb 1c                	jmp    6a0 <printf+0x12e>
          putc(fd, *s);
 684:	8b 45 f4             	mov    -0xc(%ebp),%eax
 687:	0f b6 00             	movzbl (%eax),%eax
 68a:	0f be c0             	movsbl %al,%eax
 68d:	83 ec 08             	sub    $0x8,%esp
 690:	50                   	push   %eax
 691:	ff 75 08             	pushl  0x8(%ebp)
 694:	e8 ae fd ff ff       	call   447 <putc>
 699:	83 c4 10             	add    $0x10,%esp
          s++;
 69c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a3:	0f b6 00             	movzbl (%eax),%eax
 6a6:	84 c0                	test   %al,%al
 6a8:	75 da                	jne    684 <printf+0x112>
 6aa:	eb 65                	jmp    711 <printf+0x19f>
        }
      } else if(c == 'c'){
 6ac:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b0:	75 1d                	jne    6cf <printf+0x15d>
        putc(fd, *ap);
 6b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	0f be c0             	movsbl %al,%eax
 6ba:	83 ec 08             	sub    $0x8,%esp
 6bd:	50                   	push   %eax
 6be:	ff 75 08             	pushl  0x8(%ebp)
 6c1:	e8 81 fd ff ff       	call   447 <putc>
 6c6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cd:	eb 42                	jmp    711 <printf+0x19f>
      } else if(c == '%'){
 6cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d3:	75 17                	jne    6ec <printf+0x17a>
        putc(fd, c);
 6d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d8:	0f be c0             	movsbl %al,%eax
 6db:	83 ec 08             	sub    $0x8,%esp
 6de:	50                   	push   %eax
 6df:	ff 75 08             	pushl  0x8(%ebp)
 6e2:	e8 60 fd ff ff       	call   447 <putc>
 6e7:	83 c4 10             	add    $0x10,%esp
 6ea:	eb 25                	jmp    711 <printf+0x19f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ec:	83 ec 08             	sub    $0x8,%esp
 6ef:	6a 25                	push   $0x25
 6f1:	ff 75 08             	pushl  0x8(%ebp)
 6f4:	e8 4e fd ff ff       	call   447 <putc>
 6f9:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ff:	0f be c0             	movsbl %al,%eax
 702:	83 ec 08             	sub    $0x8,%esp
 705:	50                   	push   %eax
 706:	ff 75 08             	pushl  0x8(%ebp)
 709:	e8 39 fd ff ff       	call   447 <putc>
 70e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 711:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 718:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 71c:	8b 55 0c             	mov    0xc(%ebp),%edx
 71f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 722:	01 d0                	add    %edx,%eax
 724:	0f b6 00             	movzbl (%eax),%eax
 727:	84 c0                	test   %al,%al
 729:	0f 85 65 fe ff ff    	jne    594 <printf+0x22>
    }
  }
}
 72f:	90                   	nop
 730:	c9                   	leave  
 731:	c3                   	ret    

00000732 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 732:	55                   	push   %ebp
 733:	89 e5                	mov    %esp,%ebp
 735:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 738:	8b 45 08             	mov    0x8(%ebp),%eax
 73b:	83 e8 08             	sub    $0x8,%eax
 73e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 741:	a1 74 0c 00 00       	mov    0xc74,%eax
 746:	89 45 fc             	mov    %eax,-0x4(%ebp)
 749:	eb 24                	jmp    76f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 00                	mov    (%eax),%eax
 750:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 753:	77 12                	ja     767 <free+0x35>
 755:	8b 45 f8             	mov    -0x8(%ebp),%eax
 758:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75b:	77 24                	ja     781 <free+0x4f>
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 765:	77 1a                	ja     781 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 775:	76 d4                	jbe    74b <free+0x19>
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77f:	76 ca                	jbe    74b <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	01 c2                	add    %eax,%edx
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	39 c2                	cmp    %eax,%edx
 79a:	75 24                	jne    7c0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 79c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79f:	8b 50 04             	mov    0x4(%eax),%edx
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	8b 00                	mov    (%eax),%eax
 7a7:	8b 40 04             	mov    0x4(%eax),%eax
 7aa:	01 c2                	add    %eax,%edx
 7ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7af:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	8b 00                	mov    (%eax),%eax
 7b7:	8b 10                	mov    (%eax),%edx
 7b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bc:	89 10                	mov    %edx,(%eax)
 7be:	eb 0a                	jmp    7ca <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c3:	8b 10                	mov    (%eax),%edx
 7c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cd:	8b 40 04             	mov    0x4(%eax),%eax
 7d0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	01 d0                	add    %edx,%eax
 7dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7df:	75 20                	jne    801 <free+0xcf>
    p->s.size += bp->s.size;
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 50 04             	mov    0x4(%eax),%edx
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	01 c2                	add    %eax,%edx
 7ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	8b 10                	mov    (%eax),%edx
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	89 10                	mov    %edx,(%eax)
 7ff:	eb 08                	jmp    809 <free+0xd7>
  } else
    p->s.ptr = bp;
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	8b 55 f8             	mov    -0x8(%ebp),%edx
 807:	89 10                	mov    %edx,(%eax)
  freep = p;
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	a3 74 0c 00 00       	mov    %eax,0xc74
}
 811:	90                   	nop
 812:	c9                   	leave  
 813:	c3                   	ret    

00000814 <morecore>:

static Header*
morecore(uint nu)
{
 814:	55                   	push   %ebp
 815:	89 e5                	mov    %esp,%ebp
 817:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 81a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 821:	77 07                	ja     82a <morecore+0x16>
    nu = 4096;
 823:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 82a:	8b 45 08             	mov    0x8(%ebp),%eax
 82d:	c1 e0 03             	shl    $0x3,%eax
 830:	83 ec 0c             	sub    $0xc,%esp
 833:	50                   	push   %eax
 834:	e8 e6 fb ff ff       	call   41f <sbrk>
 839:	83 c4 10             	add    $0x10,%esp
 83c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 83f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 843:	75 07                	jne    84c <morecore+0x38>
    return 0;
 845:	b8 00 00 00 00       	mov    $0x0,%eax
 84a:	eb 26                	jmp    872 <morecore+0x5e>
  hp = (Header*)p;
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 852:	8b 45 f0             	mov    -0x10(%ebp),%eax
 855:	8b 55 08             	mov    0x8(%ebp),%edx
 858:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 85b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85e:	83 c0 08             	add    $0x8,%eax
 861:	83 ec 0c             	sub    $0xc,%esp
 864:	50                   	push   %eax
 865:	e8 c8 fe ff ff       	call   732 <free>
 86a:	83 c4 10             	add    $0x10,%esp
  return freep;
 86d:	a1 74 0c 00 00       	mov    0xc74,%eax
}
 872:	c9                   	leave  
 873:	c3                   	ret    

00000874 <malloc>:

void*
malloc(uint nbytes)
{
 874:	55                   	push   %ebp
 875:	89 e5                	mov    %esp,%ebp
 877:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87a:	8b 45 08             	mov    0x8(%ebp),%eax
 87d:	83 c0 07             	add    $0x7,%eax
 880:	c1 e8 03             	shr    $0x3,%eax
 883:	83 c0 01             	add    $0x1,%eax
 886:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 889:	a1 74 0c 00 00       	mov    0xc74,%eax
 88e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 891:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 895:	75 23                	jne    8ba <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 897:	c7 45 f0 6c 0c 00 00 	movl   $0xc6c,-0x10(%ebp)
 89e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a1:	a3 74 0c 00 00       	mov    %eax,0xc74
 8a6:	a1 74 0c 00 00       	mov    0xc74,%eax
 8ab:	a3 6c 0c 00 00       	mov    %eax,0xc6c
    base.s.size = 0;
 8b0:	c7 05 70 0c 00 00 00 	movl   $0x0,0xc70
 8b7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	8b 00                	mov    (%eax),%eax
 8bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c5:	8b 40 04             	mov    0x4(%eax),%eax
 8c8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cb:	72 4d                	jb     91a <malloc+0xa6>
      if(p->s.size == nunits)
 8cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d0:	8b 40 04             	mov    0x4(%eax),%eax
 8d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8d6:	75 0c                	jne    8e4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 10                	mov    (%eax),%edx
 8dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e0:	89 10                	mov    %edx,(%eax)
 8e2:	eb 26                	jmp    90a <malloc+0x96>
      else {
        p->s.size -= nunits;
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	8b 40 04             	mov    0x4(%eax),%eax
 8ea:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8ed:	89 c2                	mov    %eax,%edx
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f8:	8b 40 04             	mov    0x4(%eax),%eax
 8fb:	c1 e0 03             	shl    $0x3,%eax
 8fe:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 901:	8b 45 f4             	mov    -0xc(%ebp),%eax
 904:	8b 55 ec             	mov    -0x14(%ebp),%edx
 907:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 90a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90d:	a3 74 0c 00 00       	mov    %eax,0xc74
      return (void*)(p + 1);
 912:	8b 45 f4             	mov    -0xc(%ebp),%eax
 915:	83 c0 08             	add    $0x8,%eax
 918:	eb 3b                	jmp    955 <malloc+0xe1>
    }
    if(p == freep)
 91a:	a1 74 0c 00 00       	mov    0xc74,%eax
 91f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 922:	75 1e                	jne    942 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 924:	83 ec 0c             	sub    $0xc,%esp
 927:	ff 75 ec             	pushl  -0x14(%ebp)
 92a:	e8 e5 fe ff ff       	call   814 <morecore>
 92f:	83 c4 10             	add    $0x10,%esp
 932:	89 45 f4             	mov    %eax,-0xc(%ebp)
 935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 939:	75 07                	jne    942 <malloc+0xce>
        return 0;
 93b:	b8 00 00 00 00       	mov    $0x0,%eax
 940:	eb 13                	jmp    955 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 942:	8b 45 f4             	mov    -0xc(%ebp),%eax
 945:	89 45 f0             	mov    %eax,-0x10(%ebp)
 948:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94b:	8b 00                	mov    (%eax),%eax
 94d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 950:	e9 6d ff ff ff       	jmp    8c2 <malloc+0x4e>
  }
}
 955:	c9                   	leave  
 956:	c3                   	ret    
