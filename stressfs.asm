
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  14:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  22:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 69 09 00 00       	push   $0x969
  30:	6a 01                	push   $0x1
  32:	e8 4d 05 00 00       	call   584 <printf>
  37:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 be 01 00 00       	call   20e <memset>
  50:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5a:	eb 0d                	jmp    69 <main+0x69>
    if(fork() > 0)
  5c:	e8 40 03 00 00       	call   3a1 <fork>
  61:	85 c0                	test   %eax,%eax
  63:	7f 0c                	jg     71 <main+0x71>
  for(i = 0; i < 4; i++)
  65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  69:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  6d:	7e ed                	jle    5c <main+0x5c>
  6f:	eb 01                	jmp    72 <main+0x72>
      break;
  71:	90                   	nop

  printf(1, "write %d\n", i);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f4             	pushl  -0xc(%ebp)
  78:	68 7c 09 00 00       	push   $0x97c
  7d:	6a 01                	push   $0x1
  7f:	e8 00 05 00 00       	call   584 <printf>
  84:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  87:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8b:	89 c2                	mov    %eax,%edx
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	01 d0                	add    %edx,%eax
  92:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 02 02 00 00       	push   $0x202
  9d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	e8 43 03 00 00       	call   3e9 <open>
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b3:	eb 1e                	jmp    d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b5:	83 ec 04             	sub    $0x4,%esp
  b8:	68 00 02 00 00       	push   $0x200
  bd:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	ff 75 f0             	pushl  -0x10(%ebp)
  c7:	e8 fd 02 00 00       	call   3c9 <write>
  cc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 20; i++)
  cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  d7:	7e dc                	jle    b5 <main+0xb5>
  close(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 f0             	pushl  -0x10(%ebp)
  df:	e8 ed 02 00 00       	call   3d1 <close>
  e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 86 09 00 00       	push   $0x986
  ef:	6a 01                	push   $0x1
  f1:	e8 8e 04 00 00       	call   584 <printf>
  f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 101:	50                   	push   %eax
 102:	e8 e2 02 00 00       	call   3e9 <open>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 10d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 114:	eb 1e                	jmp    134 <main+0x134>
    read(fd, data, sizeof(data));
 116:	83 ec 04             	sub    $0x4,%esp
 119:	68 00 02 00 00       	push   $0x200
 11e:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 f0             	pushl  -0x10(%ebp)
 128:	e8 94 02 00 00       	call   3c1 <read>
 12d:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 20; i++)
 130:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 134:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 138:	7e dc                	jle    116 <main+0x116>
  close(fd);
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	ff 75 f0             	pushl  -0x10(%ebp)
 140:	e8 8c 02 00 00       	call   3d1 <close>
 145:	83 c4 10             	add    $0x10,%esp

  wait();
 148:	e8 64 02 00 00       	call   3b1 <wait>
  
  exit();
 14d:	e8 57 02 00 00       	call   3a9 <exit>

00000152 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	57                   	push   %edi
 156:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15a:	8b 55 10             	mov    0x10(%ebp),%edx
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	89 cb                	mov    %ecx,%ebx
 162:	89 df                	mov    %ebx,%edi
 164:	89 d1                	mov    %edx,%ecx
 166:	fc                   	cld    
 167:	f3 aa                	rep stos %al,%es:(%edi)
 169:	89 ca                	mov    %ecx,%edx
 16b:	89 fb                	mov    %edi,%ebx
 16d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 170:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 173:	90                   	nop
 174:	5b                   	pop    %ebx
 175:	5f                   	pop    %edi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    

00000178 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 184:	90                   	nop
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	8d 50 01             	lea    0x1(%eax),%edx
 18b:	89 55 08             	mov    %edx,0x8(%ebp)
 18e:	8b 55 0c             	mov    0xc(%ebp),%edx
 191:	8d 4a 01             	lea    0x1(%edx),%ecx
 194:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 197:	0f b6 12             	movzbl (%edx),%edx
 19a:	88 10                	mov    %dl,(%eax)
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	84 c0                	test   %al,%al
 1a1:	75 e2                	jne    185 <strcpy+0xd>
    ;
  return os;
 1a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ab:	eb 08                	jmp    1b5 <strcmp+0xd>
    p++, q++;
 1ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	74 10                	je     1cf <strcmp+0x27>
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	0f b6 10             	movzbl (%eax),%edx
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	38 c2                	cmp    %al,%dl
 1cd:	74 de                	je     1ad <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	0f b6 d0             	movzbl %al,%edx
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	0f b6 c0             	movzbl %al,%eax
 1e1:	29 c2                	sub    %eax,%edx
 1e3:	89 d0                	mov    %edx,%eax
}
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    

000001e7 <strlen>:

uint
strlen(char *s)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f4:	eb 04                	jmp    1fa <strlen+0x13>
 1f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	84 c0                	test   %al,%al
 207:	75 ed                	jne    1f6 <strlen+0xf>
    ;
  return n;
 209:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20c:	c9                   	leave  
 20d:	c3                   	ret    

0000020e <memset>:

void*
memset(void *dst, int c, uint n)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 211:	8b 45 10             	mov    0x10(%ebp),%eax
 214:	50                   	push   %eax
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 08             	pushl  0x8(%ebp)
 21b:	e8 32 ff ff ff       	call   152 <stosb>
 220:	83 c4 0c             	add    $0xc,%esp
  return dst;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <strchr>:

char*
strchr(const char *s, char c)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 234:	eb 14                	jmp    24a <strchr+0x22>
    if(*s == c)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 23f:	75 05                	jne    246 <strchr+0x1e>
      return (char*)s;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	eb 13                	jmp    259 <strchr+0x31>
  for(; *s; s++)
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 e2                	jne    236 <strchr+0xe>
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <gets>:

char*
gets(char *buf, int max)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 268:	eb 42                	jmp    2ac <gets+0x51>
    cc = read(0, &c, 1);
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	6a 01                	push   $0x1
 26f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 272:	50                   	push   %eax
 273:	6a 00                	push   $0x0
 275:	e8 47 01 00 00       	call   3c1 <read>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 284:	7e 33                	jle    2b9 <gets+0x5e>
      break;
    buf[i++] = c;
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 c2                	add    %eax,%edx
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a0:	3c 0a                	cmp    $0xa,%al
 2a2:	74 16                	je     2ba <gets+0x5f>
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	3c 0d                	cmp    $0xd,%al
 2aa:	74 0e                	je     2ba <gets+0x5f>
  for(i=0; i+1 < max; ){
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	83 c0 01             	add    $0x1,%eax
 2b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b5:	7c b3                	jl     26a <gets+0xf>
 2b7:	eb 01                	jmp    2ba <gets+0x5f>
      break;
 2b9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 2ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	01 d0                	add    %edx,%eax
 2c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <stat>:

int
stat(char *n, struct stat *st)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	83 ec 08             	sub    $0x8,%esp
 2d3:	6a 00                	push   $0x0
 2d5:	ff 75 08             	pushl  0x8(%ebp)
 2d8:	e8 0c 01 00 00       	call   3e9 <open>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e7:	79 07                	jns    2f0 <stat+0x26>
    return -1;
 2e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ee:	eb 25                	jmp    315 <stat+0x4b>
  r = fstat(fd, st);
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	ff 75 0c             	pushl  0xc(%ebp)
 2f6:	ff 75 f4             	pushl  -0xc(%ebp)
 2f9:	e8 03 01 00 00       	call   401 <fstat>
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 304:	83 ec 0c             	sub    $0xc,%esp
 307:	ff 75 f4             	pushl  -0xc(%ebp)
 30a:	e8 c2 00 00 00       	call   3d1 <close>
 30f:	83 c4 10             	add    $0x10,%esp
  return r;
 312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <atoi>:

int
atoi(const char *s)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 324:	eb 25                	jmp    34b <atoi+0x34>
    n = n*10 + *s++ - '0';
 326:	8b 55 fc             	mov    -0x4(%ebp),%edx
 329:	89 d0                	mov    %edx,%eax
 32b:	c1 e0 02             	shl    $0x2,%eax
 32e:	01 d0                	add    %edx,%eax
 330:	01 c0                	add    %eax,%eax
 332:	89 c1                	mov    %eax,%ecx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8d 50 01             	lea    0x1(%eax),%edx
 33a:	89 55 08             	mov    %edx,0x8(%ebp)
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	0f be c0             	movsbl %al,%eax
 343:	01 c8                	add    %ecx,%eax
 345:	83 e8 30             	sub    $0x30,%eax
 348:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	3c 2f                	cmp    $0x2f,%al
 353:	7e 0a                	jle    35f <atoi+0x48>
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	0f b6 00             	movzbl (%eax),%eax
 35b:	3c 39                	cmp    $0x39,%al
 35d:	7e c7                	jle    326 <atoi+0xf>
  return n;
 35f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 376:	eb 17                	jmp    38f <memmove+0x2b>
    *dst++ = *src++;
 378:	8b 45 fc             	mov    -0x4(%ebp),%eax
 37b:	8d 50 01             	lea    0x1(%eax),%edx
 37e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 381:	8b 55 f8             	mov    -0x8(%ebp),%edx
 384:	8d 4a 01             	lea    0x1(%edx),%ecx
 387:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 38a:	0f b6 12             	movzbl (%edx),%edx
 38d:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 38f:	8b 45 10             	mov    0x10(%ebp),%eax
 392:	8d 50 ff             	lea    -0x1(%eax),%edx
 395:	89 55 10             	mov    %edx,0x10(%ebp)
 398:	85 c0                	test   %eax,%eax
 39a:	7f dc                	jg     378 <memmove+0x14>
  return vdst;
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39f:	c9                   	leave  
 3a0:	c3                   	ret    

000003a1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a1:	b8 01 00 00 00       	mov    $0x1,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <exit>:
SYSCALL(exit)
 3a9:	b8 02 00 00 00       	mov    $0x2,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <wait>:
SYSCALL(wait)
 3b1:	b8 03 00 00 00       	mov    $0x3,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <pipe>:
SYSCALL(pipe)
 3b9:	b8 04 00 00 00       	mov    $0x4,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <read>:
SYSCALL(read)
 3c1:	b8 05 00 00 00       	mov    $0x5,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <write>:
SYSCALL(write)
 3c9:	b8 10 00 00 00       	mov    $0x10,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <close>:
SYSCALL(close)
 3d1:	b8 15 00 00 00       	mov    $0x15,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <kill>:
SYSCALL(kill)
 3d9:	b8 06 00 00 00       	mov    $0x6,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <exec>:
SYSCALL(exec)
 3e1:	b8 07 00 00 00       	mov    $0x7,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <open>:
SYSCALL(open)
 3e9:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <mknod>:
SYSCALL(mknod)
 3f1:	b8 11 00 00 00       	mov    $0x11,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <unlink>:
SYSCALL(unlink)
 3f9:	b8 12 00 00 00       	mov    $0x12,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <fstat>:
SYSCALL(fstat)
 401:	b8 08 00 00 00       	mov    $0x8,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <link>:
SYSCALL(link)
 409:	b8 13 00 00 00       	mov    $0x13,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <mkdir>:
SYSCALL(mkdir)
 411:	b8 14 00 00 00       	mov    $0x14,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <chdir>:
SYSCALL(chdir)
 419:	b8 09 00 00 00       	mov    $0x9,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <dup>:
SYSCALL(dup)
 421:	b8 0a 00 00 00       	mov    $0xa,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <getpid>:
SYSCALL(getpid)
 429:	b8 0b 00 00 00       	mov    $0xb,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <sbrk>:
SYSCALL(sbrk)
 431:	b8 0c 00 00 00       	mov    $0xc,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <sleep>:
SYSCALL(sleep)
 439:	b8 0d 00 00 00       	mov    $0xd,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <uptime>:
SYSCALL(uptime)
 441:	b8 0e 00 00 00       	mov    $0xe,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <gettime>:
SYSCALL(gettime)
 449:	b8 16 00 00 00       	mov    $0x16,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <settickets>:
SYSCALL(settickets)
 451:	b8 17 00 00 00       	mov    $0x17,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 459:	55                   	push   %ebp
 45a:	89 e5                	mov    %esp,%ebp
 45c:	83 ec 18             	sub    $0x18,%esp
 45f:	8b 45 0c             	mov    0xc(%ebp),%eax
 462:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 465:	83 ec 04             	sub    $0x4,%esp
 468:	6a 01                	push   $0x1
 46a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 46d:	50                   	push   %eax
 46e:	ff 75 08             	pushl  0x8(%ebp)
 471:	e8 53 ff ff ff       	call   3c9 <write>
 476:	83 c4 10             	add    $0x10,%esp
}
 479:	90                   	nop
 47a:	c9                   	leave  
 47b:	c3                   	ret    

0000047c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47c:	55                   	push   %ebp
 47d:	89 e5                	mov    %esp,%ebp
 47f:	53                   	push   %ebx
 480:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 483:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 48a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 48e:	74 17                	je     4a7 <printint+0x2b>
 490:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 494:	79 11                	jns    4a7 <printint+0x2b>
    neg = 1;
 496:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 49d:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a0:	f7 d8                	neg    %eax
 4a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a5:	eb 06                	jmp    4ad <printint+0x31>
  } else {
    x = xx;
 4a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4b7:	8d 41 01             	lea    0x1(%ecx),%eax
 4ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c3:	ba 00 00 00 00       	mov    $0x0,%edx
 4c8:	f7 f3                	div    %ebx
 4ca:	89 d0                	mov    %edx,%eax
 4cc:	0f b6 80 fc 0b 00 00 	movzbl 0xbfc(%eax),%eax
 4d3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4da:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4dd:	ba 00 00 00 00       	mov    $0x0,%edx
 4e2:	f7 f3                	div    %ebx
 4e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4eb:	75 c7                	jne    4b4 <printint+0x38>
  if(neg)
 4ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f1:	74 2d                	je     520 <printint+0xa4>
    buf[i++] = '-';
 4f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f6:	8d 50 01             	lea    0x1(%eax),%edx
 4f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4fc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 501:	eb 1d                	jmp    520 <printint+0xa4>
    putc(fd, buf[i]);
 503:	8d 55 dc             	lea    -0x24(%ebp),%edx
 506:	8b 45 f4             	mov    -0xc(%ebp),%eax
 509:	01 d0                	add    %edx,%eax
 50b:	0f b6 00             	movzbl (%eax),%eax
 50e:	0f be c0             	movsbl %al,%eax
 511:	83 ec 08             	sub    $0x8,%esp
 514:	50                   	push   %eax
 515:	ff 75 08             	pushl  0x8(%ebp)
 518:	e8 3c ff ff ff       	call   459 <putc>
 51d:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 520:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 528:	79 d9                	jns    503 <printint+0x87>
}
 52a:	90                   	nop
 52b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 52e:	c9                   	leave  
 52f:	c3                   	ret    

00000530 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	83 ec 28             	sub    $0x28,%esp
 536:	8b 45 0c             	mov    0xc(%ebp),%eax
 539:	89 45 e0             	mov    %eax,-0x20(%ebp)
 53c:	8b 45 10             	mov    0x10(%ebp),%eax
 53f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 542:	8b 45 e0             	mov    -0x20(%ebp),%eax
 545:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 548:	89 d0                	mov    %edx,%eax
 54a:	31 d2                	xor    %edx,%edx
 54c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 54f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 552:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 555:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 559:	74 13                	je     56e <printlong+0x3e>
 55b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55e:	6a 00                	push   $0x0
 560:	6a 10                	push   $0x10
 562:	50                   	push   %eax
 563:	ff 75 08             	pushl  0x8(%ebp)
 566:	e8 11 ff ff ff       	call   47c <printint>
 56b:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 56e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 571:	6a 00                	push   $0x0
 573:	6a 10                	push   $0x10
 575:	50                   	push   %eax
 576:	ff 75 08             	pushl  0x8(%ebp)
 579:	e8 fe fe ff ff       	call   47c <printint>
 57e:	83 c4 10             	add    $0x10,%esp
}
 581:	90                   	nop
 582:	c9                   	leave  
 583:	c3                   	ret    

00000584 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 58a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 591:	8d 45 0c             	lea    0xc(%ebp),%eax
 594:	83 c0 04             	add    $0x4,%eax
 597:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 59a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5a1:	e9 88 01 00 00       	jmp    72e <printf+0x1aa>
    c = fmt[i] & 0xff;
 5a6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ac:	01 d0                	add    %edx,%eax
 5ae:	0f b6 00             	movzbl (%eax),%eax
 5b1:	0f be c0             	movsbl %al,%eax
 5b4:	25 ff 00 00 00       	and    $0xff,%eax
 5b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c0:	75 2c                	jne    5ee <printf+0x6a>
      if(c == '%'){
 5c2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c6:	75 0c                	jne    5d4 <printf+0x50>
        state = '%';
 5c8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5cf:	e9 56 01 00 00       	jmp    72a <printf+0x1a6>
      } else {
        putc(fd, c);
 5d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d7:	0f be c0             	movsbl %al,%eax
 5da:	83 ec 08             	sub    $0x8,%esp
 5dd:	50                   	push   %eax
 5de:	ff 75 08             	pushl  0x8(%ebp)
 5e1:	e8 73 fe ff ff       	call   459 <putc>
 5e6:	83 c4 10             	add    $0x10,%esp
 5e9:	e9 3c 01 00 00       	jmp    72a <printf+0x1a6>
      }
    } else if(state == '%'){
 5ee:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5f2:	0f 85 32 01 00 00    	jne    72a <printf+0x1a6>
      if(c == 'd'){
 5f8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5fc:	75 1e                	jne    61c <printf+0x98>
        printint(fd, *ap, 10, 1);
 5fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 601:	8b 00                	mov    (%eax),%eax
 603:	6a 01                	push   $0x1
 605:	6a 0a                	push   $0xa
 607:	50                   	push   %eax
 608:	ff 75 08             	pushl  0x8(%ebp)
 60b:	e8 6c fe ff ff       	call   47c <printint>
 610:	83 c4 10             	add    $0x10,%esp
        ap++;
 613:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 617:	e9 07 01 00 00       	jmp    723 <printf+0x19f>
      } else if(c == 'l') {
 61c:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 620:	75 29                	jne    64b <printf+0xc7>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 622:	8b 45 e8             	mov    -0x18(%ebp),%eax
 625:	8b 50 04             	mov    0x4(%eax),%edx
 628:	8b 00                	mov    (%eax),%eax
 62a:	83 ec 0c             	sub    $0xc,%esp
 62d:	6a 00                	push   $0x0
 62f:	6a 0a                	push   $0xa
 631:	52                   	push   %edx
 632:	50                   	push   %eax
 633:	ff 75 08             	pushl  0x8(%ebp)
 636:	e8 f5 fe ff ff       	call   530 <printlong>
 63b:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 63e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 642:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 646:	e9 d8 00 00 00       	jmp    723 <printf+0x19f>
      } else if(c == 'x' || c == 'p'){
 64b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 64f:	74 06                	je     657 <printf+0xd3>
 651:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 655:	75 1e                	jne    675 <printf+0xf1>
        printint(fd, *ap, 16, 0);
 657:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	6a 00                	push   $0x0
 65e:	6a 10                	push   $0x10
 660:	50                   	push   %eax
 661:	ff 75 08             	pushl  0x8(%ebp)
 664:	e8 13 fe ff ff       	call   47c <printint>
 669:	83 c4 10             	add    $0x10,%esp
        ap++;
 66c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 670:	e9 ae 00 00 00       	jmp    723 <printf+0x19f>
      } else if(c == 's'){
 675:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 679:	75 43                	jne    6be <printf+0x13a>
        s = (char*)*ap;
 67b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 683:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 687:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 68b:	75 25                	jne    6b2 <printf+0x12e>
          s = "(null)";
 68d:	c7 45 f4 8c 09 00 00 	movl   $0x98c,-0xc(%ebp)
        while(*s != 0){
 694:	eb 1c                	jmp    6b2 <printf+0x12e>
          putc(fd, *s);
 696:	8b 45 f4             	mov    -0xc(%ebp),%eax
 699:	0f b6 00             	movzbl (%eax),%eax
 69c:	0f be c0             	movsbl %al,%eax
 69f:	83 ec 08             	sub    $0x8,%esp
 6a2:	50                   	push   %eax
 6a3:	ff 75 08             	pushl  0x8(%ebp)
 6a6:	e8 ae fd ff ff       	call   459 <putc>
 6ab:	83 c4 10             	add    $0x10,%esp
          s++;
 6ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b5:	0f b6 00             	movzbl (%eax),%eax
 6b8:	84 c0                	test   %al,%al
 6ba:	75 da                	jne    696 <printf+0x112>
 6bc:	eb 65                	jmp    723 <printf+0x19f>
        }
      } else if(c == 'c'){
 6be:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6c2:	75 1d                	jne    6e1 <printf+0x15d>
        putc(fd, *ap);
 6c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c7:	8b 00                	mov    (%eax),%eax
 6c9:	0f be c0             	movsbl %al,%eax
 6cc:	83 ec 08             	sub    $0x8,%esp
 6cf:	50                   	push   %eax
 6d0:	ff 75 08             	pushl  0x8(%ebp)
 6d3:	e8 81 fd ff ff       	call   459 <putc>
 6d8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6df:	eb 42                	jmp    723 <printf+0x19f>
      } else if(c == '%'){
 6e1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e5:	75 17                	jne    6fe <printf+0x17a>
        putc(fd, c);
 6e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ea:	0f be c0             	movsbl %al,%eax
 6ed:	83 ec 08             	sub    $0x8,%esp
 6f0:	50                   	push   %eax
 6f1:	ff 75 08             	pushl  0x8(%ebp)
 6f4:	e8 60 fd ff ff       	call   459 <putc>
 6f9:	83 c4 10             	add    $0x10,%esp
 6fc:	eb 25                	jmp    723 <printf+0x19f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6fe:	83 ec 08             	sub    $0x8,%esp
 701:	6a 25                	push   $0x25
 703:	ff 75 08             	pushl  0x8(%ebp)
 706:	e8 4e fd ff ff       	call   459 <putc>
 70b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 70e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 711:	0f be c0             	movsbl %al,%eax
 714:	83 ec 08             	sub    $0x8,%esp
 717:	50                   	push   %eax
 718:	ff 75 08             	pushl  0x8(%ebp)
 71b:	e8 39 fd ff ff       	call   459 <putc>
 720:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 723:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 72a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 72e:	8b 55 0c             	mov    0xc(%ebp),%edx
 731:	8b 45 f0             	mov    -0x10(%ebp),%eax
 734:	01 d0                	add    %edx,%eax
 736:	0f b6 00             	movzbl (%eax),%eax
 739:	84 c0                	test   %al,%al
 73b:	0f 85 65 fe ff ff    	jne    5a6 <printf+0x22>
    }
  }
}
 741:	90                   	nop
 742:	c9                   	leave  
 743:	c3                   	ret    

00000744 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 744:	55                   	push   %ebp
 745:	89 e5                	mov    %esp,%ebp
 747:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74a:	8b 45 08             	mov    0x8(%ebp),%eax
 74d:	83 e8 08             	sub    $0x8,%eax
 750:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 753:	a1 18 0c 00 00       	mov    0xc18,%eax
 758:	89 45 fc             	mov    %eax,-0x4(%ebp)
 75b:	eb 24                	jmp    781 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 765:	77 12                	ja     779 <free+0x35>
 767:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76d:	77 24                	ja     793 <free+0x4f>
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	8b 00                	mov    (%eax),%eax
 774:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 777:	77 1a                	ja     793 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 787:	76 d4                	jbe    75d <free+0x19>
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 00                	mov    (%eax),%eax
 78e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 791:	76 ca                	jbe    75d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
 796:	8b 40 04             	mov    0x4(%eax),%eax
 799:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a3:	01 c2                	add    %eax,%edx
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	8b 00                	mov    (%eax),%eax
 7aa:	39 c2                	cmp    %eax,%edx
 7ac:	75 24                	jne    7d2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b1:	8b 50 04             	mov    0x4(%eax),%edx
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	8b 00                	mov    (%eax),%eax
 7b9:	8b 40 04             	mov    0x4(%eax),%eax
 7bc:	01 c2                	add    %eax,%edx
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	8b 10                	mov    (%eax),%edx
 7cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ce:	89 10                	mov    %edx,(%eax)
 7d0:	eb 0a                	jmp    7dc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d5:	8b 10                	mov    (%eax),%edx
 7d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7da:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	01 d0                	add    %edx,%eax
 7ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f1:	75 20                	jne    813 <free+0xcf>
    p->s.size += bp->s.size;
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	8b 50 04             	mov    0x4(%eax),%edx
 7f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fc:	8b 40 04             	mov    0x4(%eax),%eax
 7ff:	01 c2                	add    %eax,%edx
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 807:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80a:	8b 10                	mov    (%eax),%edx
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	89 10                	mov    %edx,(%eax)
 811:	eb 08                	jmp    81b <free+0xd7>
  } else
    p->s.ptr = bp;
 813:	8b 45 fc             	mov    -0x4(%ebp),%eax
 816:	8b 55 f8             	mov    -0x8(%ebp),%edx
 819:	89 10                	mov    %edx,(%eax)
  freep = p;
 81b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81e:	a3 18 0c 00 00       	mov    %eax,0xc18
}
 823:	90                   	nop
 824:	c9                   	leave  
 825:	c3                   	ret    

00000826 <morecore>:

static Header*
morecore(uint nu)
{
 826:	55                   	push   %ebp
 827:	89 e5                	mov    %esp,%ebp
 829:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 82c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 833:	77 07                	ja     83c <morecore+0x16>
    nu = 4096;
 835:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 83c:	8b 45 08             	mov    0x8(%ebp),%eax
 83f:	c1 e0 03             	shl    $0x3,%eax
 842:	83 ec 0c             	sub    $0xc,%esp
 845:	50                   	push   %eax
 846:	e8 e6 fb ff ff       	call   431 <sbrk>
 84b:	83 c4 10             	add    $0x10,%esp
 84e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 851:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 855:	75 07                	jne    85e <morecore+0x38>
    return 0;
 857:	b8 00 00 00 00       	mov    $0x0,%eax
 85c:	eb 26                	jmp    884 <morecore+0x5e>
  hp = (Header*)p;
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 864:	8b 45 f0             	mov    -0x10(%ebp),%eax
 867:	8b 55 08             	mov    0x8(%ebp),%edx
 86a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 86d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 870:	83 c0 08             	add    $0x8,%eax
 873:	83 ec 0c             	sub    $0xc,%esp
 876:	50                   	push   %eax
 877:	e8 c8 fe ff ff       	call   744 <free>
 87c:	83 c4 10             	add    $0x10,%esp
  return freep;
 87f:	a1 18 0c 00 00       	mov    0xc18,%eax
}
 884:	c9                   	leave  
 885:	c3                   	ret    

00000886 <malloc>:

void*
malloc(uint nbytes)
{
 886:	55                   	push   %ebp
 887:	89 e5                	mov    %esp,%ebp
 889:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88c:	8b 45 08             	mov    0x8(%ebp),%eax
 88f:	83 c0 07             	add    $0x7,%eax
 892:	c1 e8 03             	shr    $0x3,%eax
 895:	83 c0 01             	add    $0x1,%eax
 898:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 89b:	a1 18 0c 00 00       	mov    0xc18,%eax
 8a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a7:	75 23                	jne    8cc <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8a9:	c7 45 f0 10 0c 00 00 	movl   $0xc10,-0x10(%ebp)
 8b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b3:	a3 18 0c 00 00       	mov    %eax,0xc18
 8b8:	a1 18 0c 00 00       	mov    0xc18,%eax
 8bd:	a3 10 0c 00 00       	mov    %eax,0xc10
    base.s.size = 0;
 8c2:	c7 05 14 0c 00 00 00 	movl   $0x0,0xc14
 8c9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cf:	8b 00                	mov    (%eax),%eax
 8d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	8b 40 04             	mov    0x4(%eax),%eax
 8da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8dd:	72 4d                	jb     92c <malloc+0xa6>
      if(p->s.size == nunits)
 8df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e2:	8b 40 04             	mov    0x4(%eax),%eax
 8e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e8:	75 0c                	jne    8f6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ed:	8b 10                	mov    (%eax),%edx
 8ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f2:	89 10                	mov    %edx,(%eax)
 8f4:	eb 26                	jmp    91c <malloc+0x96>
      else {
        p->s.size -= nunits;
 8f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f9:	8b 40 04             	mov    0x4(%eax),%eax
 8fc:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8ff:	89 c2                	mov    %eax,%edx
 901:	8b 45 f4             	mov    -0xc(%ebp),%eax
 904:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 907:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90a:	8b 40 04             	mov    0x4(%eax),%eax
 90d:	c1 e0 03             	shl    $0x3,%eax
 910:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 913:	8b 45 f4             	mov    -0xc(%ebp),%eax
 916:	8b 55 ec             	mov    -0x14(%ebp),%edx
 919:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 91c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91f:	a3 18 0c 00 00       	mov    %eax,0xc18
      return (void*)(p + 1);
 924:	8b 45 f4             	mov    -0xc(%ebp),%eax
 927:	83 c0 08             	add    $0x8,%eax
 92a:	eb 3b                	jmp    967 <malloc+0xe1>
    }
    if(p == freep)
 92c:	a1 18 0c 00 00       	mov    0xc18,%eax
 931:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 934:	75 1e                	jne    954 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 936:	83 ec 0c             	sub    $0xc,%esp
 939:	ff 75 ec             	pushl  -0x14(%ebp)
 93c:	e8 e5 fe ff ff       	call   826 <morecore>
 941:	83 c4 10             	add    $0x10,%esp
 944:	89 45 f4             	mov    %eax,-0xc(%ebp)
 947:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94b:	75 07                	jne    954 <malloc+0xce>
        return 0;
 94d:	b8 00 00 00 00       	mov    $0x0,%eax
 952:	eb 13                	jmp    967 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 954:	8b 45 f4             	mov    -0xc(%ebp),%eax
 957:	89 45 f0             	mov    %eax,-0x10(%ebp)
 95a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95d:	8b 00                	mov    (%eax),%eax
 95f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 962:	e9 6d ff ff ff       	jmp    8d4 <malloc+0x4e>
  }
}
 967:	c9                   	leave  
 968:	c3                   	ret    
